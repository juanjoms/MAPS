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


function load_bpmn(){
  var BpmnJS = window.BpmnJS;
  //CliModule = new Cli();
  var bpmnjs = new BpmnJS({
    container: '#canvas',
    zoomScroll: { enabled: false },
    additionalModules: [CliModule],
    cli: { bindTo: 'cli' }
  });
  //var file_path = "./resources/diagram.bpmn";
  var file_path = "assets/ini_diagram.bpmn"

  //Open Diagram
  $.get(file_path, function(diagram) {
    bpmnjs.importXML(diagram, function(err){
      if (err) { console.log(err); }
      try {
        bpmnjs.get('canvas').zoom('fit-viewport');
      } catch (e) {
        console.log(e);
      }
    });
  }, 'text');
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
