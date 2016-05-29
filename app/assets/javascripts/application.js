// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap.min
//= require jquery.raty
//= require ratyrate
//= require bpmn-modeler.min
//= require bundle-cli
//= require turbolinks

$(document).ready(function(){
  toggle_rate();
  $('[data-toggle="tooltip"]').tooltip()
  $('body').on('click', '#save-diagram', save_diagram);
  $('body').on('click', '#completed_survey', completed_survey);

  $('#company_employees_number').on('input', calc_sample_size );

  $('.accordion').click(function(){
    $(this).next().slideToggle();
    $(this).children().toggleClass('fa-caret-up');
    $(this).toggleClass('open');
  });

  $('.show-guides').click(function(){
    $(this).closest('tr').next().slideToggle();
    $(this).children().toggleClass('fa-chevron-down');
  });
});

function toggle_rate(){
  $('body').on('change', "input[type='radio']", function(){
    if(this.value < 3){
      $('.star').fadeTo(200, 0);
      $('.added-value-title').fadeTo(200, 0);
    }else{
      $('.star').fadeTo(200, 1);
      $('.added-value-title').fadeTo(200, 1);
    }
  });
}

var bpmnjs, canvas;
function load_bpmn(diagramXML, company_name){
  var BpmnViewer = window.BpmnJS;
  bpmnjs = new BpmnViewer({
    container: '#canvas',
    zoomScroll: { enabled: false },
    additionalModules: [CliModule],
    cli: { bindTo: 'cli' }
  });
  //import diagram
  bpmnjs.importXML(diagramXML, function(err) {
    if (err) { console.log(err); }
    canvas = bpmnjs.get('canvas');
    //canvas.zoom('fit-viewport');
    canvas.zoom(1);
  });
  waitForCliToResize(company_name);
}

function waitForCliToResize(company_name){
  if(typeof cli !== "undefined")
  {
    cli.setLabel('Participant_1jxwwcj', company_name);
    resize_canvas();
  }
  else{ setTimeout(function(){ waitForCliToResize(company_name); },250); }
}


function save_diagram(){
  bpmnjs.saveXML(function(err, xml){
    $.ajax({
      url: "/user_practice",
      type: "POST",
      data: {xml_diagram: xml},
      success: function(resp){ console.log("Diagram saved"); },
      error: function(){
        console.err("Error al guardar diagrama");
      }
    });
  });
  window.location.href = "/results";
}

function completed_survey(){
  window.location.href = "/results";
}


function saveSVG(done) {
  console.log(bpmnjs.saveSVG(done));
}

function saveDiagram(done) {
  bpmnjs.saveXML({ format: true }, function(err, xml) {
    done(err, xml);
  });
}

missing_lane = "";
function add_missing_lane(){
  /* Recorriendo carriles hacia abajo*/
  var elems = cli.elements();
  for(j in elems){
    if(elems[j].startsWith("Participant")){
      cli.move(elems[j], {x:0, y:130});
    }
  }
  /* Añadiendo carrill al principio */
  var width = cli.element('Participant_1jxwwcj').width;
  missing_lane = cli.create("bpmn:Participant",  {x:78, y:20, width:width, height:120}, "Collaboration_07pzko3");
}

x = 0;
function add_missing_practice(practice){
  var is_missing = true;
  var elems = cli.elements();
  for(j in elems){
    var elem = cli.element(elems[j]);
    if(practice == elem.businessObject.name){
      is_missing = false;
      break;
    }
  }

  if(is_missing){
    var missing_practice = cli.create("bpmn:Task", {x:160+x,y:80}, missing_lane);
    cli.setLabel(missing_practice, practice);
    canvas.addMarker(missing_practice, 'highlight');
    x += 150;
  }
}

function delete_lane_if_empty(){
  if (cli.element(missing_lane).children.length == 0){
    cli.removeShape(missing_lane);
    /* Recorriendo carriles hacia arriba */
    var elems = cli.elements();
    for(j in elems){
      if(elems[j].startsWith("Participant")){
        console.log(elems[j]);
        cli.move(elems[j], {x:0, y:-130});
      }
    }
  }

}

function remove_practice(practice){
  var elements = cli.elements();

  for(i in elements){
    var elem = cli.element(elements[i]);
    if(practice == elem.businessObject.name){
      var incoming_id = cli.element(elem.id).incoming[0].source.id;
      if(cli.element(elem.id).outgoing.length > 0){
        var outgoing_id = cli.element(elem.id).outgoing[0].target.id;
        cli.connect(incoming_id, outgoing_id, 'bpmn:SequenceFlow');
      }
      cli.removeShape(elem.id);
      break;
    }
  }
}

function change_practice(p_old, p_new){
  var elements = cli.elements();

  for(i in elements){
    var elem = cli.element(elements[i]);

    if(p_old == elem.businessObject.name){
      cli.setLabel(elem, p_new);
      break;
    }
  }
}

/* Resize canvas:
  Aumenta el tamaño del div para
  que aparesca el scroll bar */
function resize_canvas(scrollLeft){
  var elems = cli.elements();
  width = 0;
  for(var i=0; i< elems.length; i++){
    if(elems[i].startsWith("Participant")){
      var elem = cli.element(elems[i]);
      if (width < elem.width + 100)
        width = elem.width + 100;
    }
  }
  $("#canvas").width(width + "px");
  if(scrollLeft)
    $(".scroll-canvas").scrollLeft(width);
}


function calc_sample_size(){
  var N = $('#company_employees_number').val();
  var variance_p = 0.3 * 0.3;  //Varianza al cuadrado
  var confidence_p = 1.28 * 1.28;
  var error_p= 0.1 * 0.1;

  //var n = (N*(variance**2)*(confidence**2)) / ( (error**2)*(N-1) + (variance**2) * (confidence**2) );
  var n = (N * variance_p * confidence_p) / ( error_p * (N-1) + (variance_p) * (confidence_p) );
  $('#sample-size').val(Math.round(n));
}

/*
//Diagram my custom functions
function add_element(element_name){
  var element = 'StartEvent_15g66lo';
  var new_element = cli.append(element, 'bpmn:Task', '150,0');
  cli.setLabel(new_element, element_name);
}

$(document).on("ajax:success", "form#up_form", function(e, data){
  add_element("Practica 1");
  //console.log(data.practice.id);
});

$(document).on("ajax:error", "form#up_form", function(e, data){
  console.log(data);
});
*/
