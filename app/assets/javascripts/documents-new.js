boxfile.action('documents#new', function() {
  // window.setTimeout(function() {
  //   $('div.off-canvas-wrap').foundation('offcanvas', 'show', 'move-left');
  // }, 500);

  var generateUUID4 = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  }

  var createPageInput = function(capture, accept) {
    var uuid = 'page-' + generateUUID4();
    var inputField = $('<input/>').attr({
      'type': 'file',
      'accept': accept,
      'capture': capture,
      'name': 'page[]',
      'id': uuid
    });

    var listElement = $('<li/>');

    return listElement
      .append(
        $('<label/>').attr('id', uuid)
      )
      .append(inputField.css({
        'display': 'inline-block',
        'width': 'auto'
      }))
      .append(
        $('<span/>').addClass('fa fa-close fa-lg').css('float', 'right').click(function() {
          listElement.remove();
        })
      );
  }

  var pagesContainer = $('section#panel2-1 > ol#pages');
  $('.button.add-page').click(function() {
    pagesContainer.append(createPageInput('camera', 'image/png,image/jpg,image/jpeg'));
  }).click();
});
