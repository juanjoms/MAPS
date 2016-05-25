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

var bpmnjs;
function load_bpmn(diagramXML){
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
    var canvas = bpmnjs.get('canvas');
    //canvas.zoom('fit-viewport');
    canvas.zoom(1);
  });
  waitForCliToResize(false);

}

function waitForCliToResize(){
  if(typeof cli !== "undefined")
  {
    resize_canvas();
  }
  else{ setTimeout(function(){ waitForCliToResize(); },250); }
}


function save_diagram(){
  bpmnjs.saveXML(function(err, xml){
    $.ajax({
      url: "/user_practice",
      type: "POST",
      data: {xml_diagram: xml},
      success: function(resp){ console.log("Diagram saved"); }
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


function add_missing_lane(){
  /* Recorriendo carriles hacia abajo*/
  var elems = cli.elements();
  for(j in elems){
    var elem = elems[j];
    if(elem.startsWith("Participant")){
      cli.move(elem, {x:0, y:130});
    }
  }
  /* Añadiendo carrill al principio */
  var lane = cli.create("bpmn:Participant",  {x:78, y:20, width:1200, height:120}, "Collaboration_07pzko3");
  cli.setLabel(lane, "Prácticas faltantes que aportan valor");
  return lane;
}

x = 0;
function add_missing_practice(practice, lane){
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
    var missing_practice = cli.create("bpmn:Task", {x:160+x,y:80}, lane);
    cli.setLabel(missing_practice, practice);
    x += 150;
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
      if (width < elem.width )
        width = elem.width + 100;
    }
  }
  $("#canvas").width(width + "px");
  if(scrollLeft)
    $(".scroll-canvas").scrollLeft(width);
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
