class UserPracticeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :association_complete!

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
    @cont_users = @company.users.count
    @sample = @company.employees_number / 2 + 1
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

  def save_initial_diagram!
    current_user.company.update(as_is_diagram: '<?xml version="1.0" encoding="UTF-8"?><definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="http://bpmn.io" exporterVersion="0.10.1"><collaboration id="Collaboration_07pzko3"><participant id="Participant_1jxwwcj" name="Líder de Proyecto" processRef="Process_1" /><participant id="Participant_0n8p39h" name="Equipo de Desarrollo" processRef="Process_0hiy31e" /></collaboration><process id="Process_1" isExecutable="false"><startEvent id="StartEvent_0gwlf1v" /></process><process id="Process_0hiy31e" /><bpmndi:BPMNDiagram id="BpmnDiagram_1"><bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Collaboration_07pzko3"><bpmndi:BPMNShape id="Participant_1jxwwcj_di" bpmnElement="Participant_1jxwwcj"><omgdc:Bounds x="78" y="20" width="787" height="184" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Participant_0n8p39h_di" bpmnElement="Participant_0n8p39h"><omgdc:Bounds x="78" y="204" width="787" height="183" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="StartEvent_0gwlf1v_di" bpmnElement="StartEvent_0gwlf1v"><omgdc:Bounds x="131" y="90" width="36" height="36" /><bpmndi:BPMNLabel><omgdc:Bounds x="104" y="126" width="90" height="20" /></bpmndi:BPMNLabel></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></definitions>')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_practice_params
    params.require(:user_practice).permit(:answer)
  end

end
