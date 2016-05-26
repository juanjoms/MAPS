class UserPracticeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_complete!
  before_action :association_complete!

  initial_diagram = '<?xml version="1.0" encoding="UTF-8"?><definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="http://bpmn.io" exporterVersion="0.10.1"><collaboration id="Collaboration_07pzko3"><participant id="Participant_1jxwwcj" name="Empresa" processRef="Process_1" /></collaboration><process id="Process_1" isExecutable="false"><laneSet><lane id="Lane_1421xum" name="Equipo de desarrollo"><childLaneSet xsi:type="tLaneSet" /></lane><lane id="Lane_1aj5j1l" name="Líder de Proyecto"><flowNodeRef>StartEvent_0gwlf1v</flowNodeRef></lane></laneSet><startEvent id="StartEvent_0gwlf1v" /></process><bpmndi:BPMNDiagram id="BpmnDiagram_1"><bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Collaboration_07pzko3"><bpmndi:BPMNShape id="Participant_1jxwwcj_di" bpmnElement="Participant_1jxwwcj"><omgdc:Bounds x="78" y="20" width="826" height="367" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="StartEvent_0gwlf1v_di" bpmnElement="StartEvent_0gwlf1v"><omgdc:Bounds x="161" y="91" width="36" height="36" /><bpmndi:BPMNLabel><omgdc:Bounds x="134" y="127" width="90" height="20" /></bpmndi:BPMNLabel></bpmndi:BPMNShape><bpmndi:BPMNShape id="Lane_1aj5j1l_di" bpmnElement="Lane_1aj5j1l"><omgdc:Bounds x="108" y="20" width="796" height="184" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Lane_1421xum_di" bpmnElement="Lane_1421xum"><omgdc:Bounds x="108" y="204" width="796" height="183" /></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></definitions>'

  def index
    @company = current_user.company

    if @company.as_is_diagram.nil?
      @diagramXML = initial_diagram
      #save_initial_diagram!
    else
      @diagramXML = @company.as_is_diagram.squish
    end

    user_practices = UserPractice.where(user_id: current_user.id)
    user_practices.each do |up|
      if up.answer.nil?
        @current_user_practice = up
        break
      end
    end

    if @current_user_practice.nil? and current_user.is_process_user?
      redirect_to results_path
    elsif !@current_user_practice.nil?
      @progress = @current_user_practice.practice.progress - (1/14.0*100)
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
    #current_user.company.update(as_is_diagram: '<?xml version="1.0" encoding="UTF-8"?><definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="http://bpmn.io" exporterVersion="0.10.1"><collaboration id="Collaboration_07pzko3"><participant id="Participant_1jxwwcj" name="Líder de Proyecto" processRef="Process_1" /><participant id="Participant_0n8p39h" name="Equipo de Desarrollo" processRef="Process_0hiy31e" /></collaboration><process id="Process_1" isExecutable="false"><startEvent id="StartEvent_0gwlf1v" /></process><process id="Process_0hiy31e" /><bpmndi:BPMNDiagram id="BpmnDiagram_1"><bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Collaboration_07pzko3"><bpmndi:BPMNShape id="Participant_1jxwwcj_di" bpmnElement="Participant_1jxwwcj"><omgdc:Bounds x="78" y="20" width="787" height="184" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Participant_0n8p39h_di" bpmnElement="Participant_0n8p39h"><omgdc:Bounds x="78" y="204" width="787" height="183" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="StartEvent_0gwlf1v_di" bpmnElement="StartEvent_0gwlf1v"><omgdc:Bounds x="131" y="90" width="36" height="36" /><bpmndi:BPMNLabel><omgdc:Bounds x="104" y="126" width="90" height="20" /></bpmndi:BPMNLabel></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></definitions>')
    #current_user.company.update(as_is_diagram: '<?xml version="1.0" encoding="UTF-8"?><definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="http://bpmn.io" exporterVersion="0.10.1"><collaboration id="Collaboration_07pzko3"><participant id="Participant_1jxwwcj" name="Empresa" processRef="Process_1" /></collaboration><process id="Process_1" isExecutable="false"><laneSet><lane id="Lane_1421xum" name="Equipo de desarrollo"><childLaneSet xsi:type="tLaneSet" /></lane><lane id="Lane_1aj5j1l" name="Líder de Proyecto"><flowNodeRef>StartEvent_0gwlf1v</flowNodeRef></lane></laneSet><startEvent id="StartEvent_0gwlf1v" /></process><bpmndi:BPMNDiagram id="BpmnDiagram_1"><bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Collaboration_07pzko3"><bpmndi:BPMNShape id="Participant_1jxwwcj_di" bpmnElement="Participant_1jxwwcj"><omgdc:Bounds x="78" y="20" width="826" height="367" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="StartEvent_0gwlf1v_di" bpmnElement="StartEvent_0gwlf1v"><omgdc:Bounds x="161" y="91" width="36" height="36" /><bpmndi:BPMNLabel><omgdc:Bounds x="134" y="127" width="90" height="20" /></bpmndi:BPMNLabel></bpmndi:BPMNShape><bpmndi:BPMNShape id="Lane_1aj5j1l_di" bpmnElement="Lane_1aj5j1l"><omgdc:Bounds x="108" y="20" width="796" height="184" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Lane_1421xum_di" bpmnElement="Lane_1421xum"><omgdc:Bounds x="108" y="204" width="796" height="183" /></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></definitions>')
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_practice_params
    params.require(:user_practice).permit(:answer)
  end

end
