class UserPracticeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :association_complete!
  before_action :setup_show_results!

  def index
    if current_user.company.as_is_diagram.nil?
      save_initial_diagram!
    end
    @diagramXML = current_user.company.as_is_diagram.squish

    user_practices = UserPractice.where(user_id: current_user.id)
    user_practices.each do |up|
      if up.answer.nil?
        @current_user_practice = up
        break
      end
    end
  end

  # PATCH /user_practice/:id
  def update
    @company = current_user.company
    @current_user_practice = UserPractice.find(params[:id])
    respond_to do |format|
      if @current_user_practice.update(user_practice_params)
        format.html { redirect_to user_practice_index_path }
        format.js
      else
        raise "Nope, no se creó"
      end
    end
  end

  def create
    @company = current_user.company
    if @company.update({as_is_diagram: params['xml_diagram'], final_element: params['fe']})
      render :json => { response:"diagram saved" } # send back any data if necessary
    else
      render :json => { response: "Diagram not saved" }, :status => 500
    end
  end

  def done
    @company = current_user.company
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

      #################################
     ### Analisis el valor añadido ###
    #################################
    @value_matrix = []
    practices = Practice.all
    practices.each do |practice|
      sum = 0
      cont = 0
      @company.users.each do |user|
        up = UserPractice.where('user_id': user.id, practice_id: practice.id).last
        if !up.answer.nil?
          sum += up.added_value
          cont += 1
        end
      end
      average = sum / cont
      index = (average / 5) * 100
      @value_matrix.push([practice.name, index, value_range(index), value_anlys(index), practice.id])
    end

    ##################################
   ### Mapeo a prácticas de Scrum ###
  ##################################
  @scrum_matrix = []
  @value_matrix.each do |p|
    if (p[1] < 76) and (p[1] > 25)
      scrump = ScrumPractice.where(practice_id: p[4]).last;
      @scrum_matrix.push([p[0], scrump.supported, scrump.name ])
    end
  end
end


  private
  def association_complete!
    user_practices = UserPractice.where("user_id": current_user.id)
    if user_practices.count == 0
      practices = Practice.all
      practices.each do |practice|
        UserPractice.create(user_id: current_user.id, practice_id: practice.id)
      end
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

  def questions_answered?(user)
    user_practices = UserPractice.where("user_id": user.id)
    return !user_practices.last.answer.nil?
  end

  def save_initial_diagram!
    current_user.company.update(as_is_diagram: '<?xml version="1.0" encoding="UTF-8"?><definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="http://bpmn.io" exporterVersion="0.10.1"><collaboration id="Collaboration_07pzko3"><participant id="Participant_1jxwwcj" name="Líder de Proyecto" processRef="Process_1" /><participant id="Participant_0n8p39h" name="Equipo de Desarrollo" processRef="Process_0hiy31e" /></collaboration><process id="Process_1" isExecutable="false"><startEvent id="StartEvent_0gwlf1v" /></process><process id="Process_0hiy31e" /><bpmndi:BPMNDiagram id="BpmnDiagram_1"><bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Collaboration_07pzko3"><bpmndi:BPMNShape id="Participant_1jxwwcj_di" bpmnElement="Participant_1jxwwcj"><omgdc:Bounds x="78" y="20" width="787" height="184" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Participant_0n8p39h_di" bpmnElement="Participant_0n8p39h"><omgdc:Bounds x="78" y="204" width="787" height="183" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="StartEvent_0gwlf1v_di" bpmnElement="StartEvent_0gwlf1v"><omgdc:Bounds x="131" y="90" width="36" height="36" /><bpmndi:BPMNLabel><omgdc:Bounds x="104" y="126" width="90" height="20" /></bpmndi:BPMNLabel></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></definitions>')
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


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_practice_params
    params.require(:user_practice).permit(:answer)
  end

end
