class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!

  def index
    @company = current_user.company

    #Cálculo del tamaño muestral
    eN = @company.employees_number
    variance_p   = 0.3 * 0.3; # variance powered 2
    confidence_p = 1.28 * 1.28; # confidence powered 2
    error_p      = 0.1 * 0.1;  # error powered 2
    n = (eN * variance_p * confidence_p) / ( error_p * (eN-1) + (variance_p) * (confidence_p) )
    @sample = n.round

    #Checo si el numero de usuarios que han
    #contestado es igual o mayor a la muestra
    @cont_users = 0
    @company.users.each do |user|
      up = UserPractice.where(user_id: user.id).last
      if !up.nil? and !up.answer.nil?
        @cont_users += 1
      end
    end
    if @cont_users >= @sample
      @complete_sample = true
    else
      return
    end

    #Checo que se creó el diagrama: el SEPG modeló el proceso
    if @company.as_is_diagram.nil?
      @no_diagram = "El encargado de mejoras aún no ha diagramado el proceso de la empresa."
    else
      @diagramXML = @company.as_is_diagram.squish
    end

    @value_matrix = []  #Added value array
    @scrum_matrix = []  #Scrum practices array
    @tools_matrix = []  #Tools and techniques array
    @diagram_matrix=[]  #Practicas que deben estar en el diagrama
    @delete_matrix= []  #Practices to be deleted
    @changes_matrix=[]  #Practices to be changed

    #################################
    ### Analisis el valor añadido ###
    #################################
    practices = Practice.all
    practices.each do |practice|
      av_list = []
      @company.users.each do |user|
        up = UserPractice.where('user_id': user.id, practice_id: practice.id).last
        if !up.nil? and !up.answer.nil?
          av_list.push(up.added_value)
        end
      end

      #Detect outliers
      outliers = detect_outliers(av_list)
      outliers.each do |outlier|
        av_list.delete(outlier)
      end

      #Calc average and index number
      average = av_list.sum / av_list.length.to_f
      index = (average / 5.0) * 100
      @value_matrix.push([practice.id, practice.name, index, value_range(index), value_anlys(index), value_class(index), practice.necessary])
    end

    ##################################
    ### Mapeo a prácticas de Scrum ###
    ### y técnicas y herramientas  ###
    ##################################
    @value_matrix.each do |p|
      #Practicas entre 26-75, o menores a 25 solo si son indispensable
      if (p[2] > 25 and p[2] <= 75) or (p[2] <= 25 and p[6] == 1)
        scrump = ScrumPractice.where(practice_id: p[0]).last;
        @scrum_matrix.push([p[0], p[1], supported_class(scrump.supported), supported_tooltip(scrump.supported),
        scrump.name, scrump.supported, scrump.description, scrump.meeting, scrump.ingredients,
        scrump.procedure, scrump.tools, scrump.techniques, scrump.duration]);
        @diagram_matrix.push(p[1]);
        if scrump.supported > 0
          @changes_matrix.push([p[1], scrump.name])
        else
          append_technique_tool(p[0], p[1], p[5])
        end
      elsif p[2] >= 76
        append_technique_tool(p[0], p[1], p[5])
        @diagram_matrix.push(p[1]);
      elsif p[2] <= 25
        @delete_matrix.push(p[1])
      end
    end
  end


  private

  # Examples and more about this function:
  # https://gist.github.com/juanjo23/66babe93c732043b4abad3c8f973aea7
  def detect_outliers(list_nums)
    average = list_nums.sum.to_f / list_nums.length
    sup = 0
    inf = 0
    list_sup = []
    list_inf = []

    list_nums.each do |i|
      #Superior outliers
      if i - average >= 3
        list_sup.push(i)
        sup += 1
      end
      #Inferior outliers
      if average - i >= 3
        list_inf.push(i)
        inf += 1
      end
    end

    #Checks if there are outliers and they are smaller than 25%
    if sup > 0 and sup.to_f / list_nums.length <= 0.25
      return list_sup
    end

    if inf > 0 and inf.to_f / list_nums.length <= 0.25
      return list_inf
    end

    return []
  end

  def append_technique_tool(practice_id, practice_name, practice_class)
    @tools_matrix.push([practice_id, practice_name, practice_class, {:easy => [], :medium => [], :hard =>[]} ])
    techtool = TechniqueTool.where(practice_id: practice_id)
    techtool.each do |tt|
      if tt.complexity == 0
        @tools_matrix.last[3][:easy].push(tt.name)
      elsif tt.complexity == 1
        @tools_matrix.last[3][:medium].push(tt.name)
      else
        @tools_matrix.last[3][:hard].push(tt.name)
      end
    end
  end

  def value_anlys(index)
    if index <= 25
      return "No aporta valor"
    elsif index <= 50
      return "Aporta poco valor"
    elsif index <= 75
      return "Aporta valor"
    else
      return "Mejor práctica"
    end
    #code
  end

  def value_range(index)
    if index <= 25
      return "1-25"
    elsif index <= 50
      return "26-50"
    elsif index <= 75
      return "51-75"
    else
      return "76-100"
    end
  end

  def value_class(index)
    if index <= 25
      return "danger"
    elsif index <= 50
      return "warning"
    elsif index <= 75
      return "info"
    else
      return "success"
    end
  end

  def supported_class(support)
    if support == 0
      return "fa fa-battery-empty"
    elsif support == 1
      return "fa fa-battery-half"
    else
      return "fa fa-battery-full"
    end
  end

  def supported_tooltip(support)
    if support == 0
      return "No soportada"
    elsif support == 1
      return "Parcialmente soportada"
    else
      return "Soportada"
    end
  end

end
