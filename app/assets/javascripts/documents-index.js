paperless.action('documents#index', function() {
  // window.setTimeout(function() {
  //   $('div.off-canvas-wrap').foundation('offcanvas', 'show', 'move-left');
  // }, 500);
  //
  console.log("Faye");
  var client = new Faye.Client('/faye');
  window.fayeclient = client;

  var subscription = client
    .subscribe('/document-status', function(message) {
      console.log("Message received!", message);
    })
    .then(function() {
      console.log('document-status channel subscribed!');
    });
});

