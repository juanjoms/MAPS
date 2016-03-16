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
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function load_bpmn(){
  var BpmnJS = window.BpmnJS;
  //CliModule = new Cli();
  var bpmnjs = new BpmnJS({
    container: '#canvas',
    additionalModules: [CliModule],
    cli: { bindTo: 'cli' }
  });
  //var file_path = "./resources/diagram.bpmn";
  var file_path = "https://doc-0k-a8-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/ucnuhehbce8s16o1e609ucrp1fpbjnta/1458100800000/07871990755708040257/*/0B1eZCQt-wxVgcTZ2V2MwZ2hjUk0?e=download"

  //Open Diagram
  $.get(file_path, function(diagram) {
    bpmnjs.importXML(diagram, function(err){
      if (err) { console.log(err); }
      try {
        bpmnjs.get('canvas').zoom('fit-viewport');
        console.log("success");
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



$(document).on('ready', function(){
  if ( $( "#canvas" ).length ) {
    console.log("Canvas exists and is loaded");
    alert("Canvas exists and is loaded");
  }else{
    console.log("Canvas donesnt exists");
  }

});
