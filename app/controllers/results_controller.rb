class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :setup_show_results!

  def index
    @company = current_user.company
    @diagramXML = @company.as_is_diagram.squish
    @sample = @company.employees_number / 2 + 1

    @cont_users = 0
    @company.users.each do |user|
      practice = UserPractice.where(user_id: user.id).last
      if !practice.answer.nil?
        @cont_users += 1
      end
    end
    if @cont_users >= @sample
      @complete_sample = true
    else
      return
    end

    @value_matrix = []  #Added value array
    @scrum_matrix = []  #Scrum practices array
    @tools_matrix = []  #Tools and techniques array
    @delete_matrix= []  #Practices to be deleted
    @changes_matrix=[]  #Practices to be changed

      #################################
     ### Analisis el valor añadido ###
    #################################
    practices = Practice.all
    practices.each do |practice|
      sum = 0
      cont = 0
      max_score = 0
      @company.users.each do |user|
        up = UserPractice.where('user_id': user.id, practice_id: practice.id).last
        if !up.answer.nil?
          sum += up.added_value
          cont += 1
          if up.added_value > max_score
            max_score = up.added_value
          end
        end
      end
      average = sum / cont
      index = (average / max_score) * 100
      @value_matrix.push([practice.id, practice.name, index, value_range(index), value_anlys(index), value_class(index)])
    end

       ##################################
      ### Mapeo a prácticas de Scrum ###
     ### y técnicas y herramientas  ###
    ##################################
    @value_matrix.each do |p|
      if (p[2] < 76) and (p[2] > 25)
        scrump = ScrumPractice.where(practice_id: p[0]).last;
        @scrum_matrix.push([p[0], p[1], supported_class(scrump.supported), supported_tooltip(scrump.supported),
          scrump.name, scrump.supported, scrump.description, scrump.meeting, scrump.ingredients,
          scrump.procedure, scrump.tools, scrump.techniques, scrump.duration]);
        if scrump.supported > 0
          @changes_matrix.push([p[1], scrump.name])
        else
          append_technique_tool(p[0], p[1], p[5])
        end
      elsif p[2] >= 76
        append_technique_tool(p[0], p[1], p[5])
      elsif p[2] <= 25
        @delete_matrix.push(p[1])
      end
    end
  end


  private
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
    if index < 26
      return "No aporta valor"
    elsif index < 51
      return "Aporta poco valor"
    elsif index < 76
      return "Aporta valor"
    else
      return "Mejor práctica"
    end
    #code
  end

  def value_range(index)
    if index < 26
      return "1-25"
    elsif index < 51
      return "26-50"
    elsif index < 76
      return "51-75"
    else
      return "76-100"
    end
  end

  def value_class(index)
    if index < 26
      return "danger"
    elsif index < 51
      return "warning"
    elsif index < 76
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

  def setup_show_results!
    user_practices = UserPractice.where("user_id": current_user.id)
    if user_practices.last.answer.nil?
      session[:show_results] = false
    else
      session[:show_results] = true
    end
  end


end
