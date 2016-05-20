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
//= require bpmn-modeler
//= require bundle-cli
//= require turbolinks

$(document).ready(function(){
  toggle_rate();
  $('[data-toggle="tooltip"]').tooltip()
  $('body').on('click', '#save-diagram', save_diagram);

  $('.accordion').click(function(){
    $(this).next().slideToggle();
    $(this).children().toggleClass('fa-caret-up');
    $(this).toggleClass('open');
  });

  $('.show-guides').click(function(){
    $(this).closest('tr').next().slideToggle();
    $(this).children().toggleClass('fa-chevron-up');
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
  var BpmnJS = window.BpmnJS;
  bpmnjs = new BpmnJS({
    container: '#canvas',
    zoomScroll: { enabled: false },
    additionalModules: [CliModule],
    cli: { bindTo: 'cli' }
  });
  //import diagram
  bpmnjs.importXML(diagramXML, function(err) {
    if (err) { console.log(err); }
    var canvas = bpmnjs.get('canvas');
    canvas.zoom('fit-viewport');
  });

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
  window.location.href = "/done";
}



function saveSVG(done) {
  console.log(bpmnjs.saveSVG(done));
}

function saveDiagram(done) {
  bpmnjs.saveXML({ format: true }, function(err, xml) {
    done(err, xml);
  });
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
