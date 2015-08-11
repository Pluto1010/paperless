$(function() {
  var searchField = $('ul.off-canvas-list li.search input[type=text]');

  $('ul.off-canvas-list a.clear').click(function() {
    $(this).parents('form').find('ul.tags > input[type=checkbox]').removeAttr('checked');
    searchField.val('');
    searchField.keyup();
    return false;
  });

  searchField.focus(function() {
    $("html,body").animate(
      {
        scrollTop: $(this).offset().top
      }, 500
    );
  });

  searchField.keyup(function() {
    var field = $(this);
    var tagList = field.parents('form').find('ul.tags')[0];

    if(field.val() != '') {
      $('li.tag', tagList).hide();
      $('li.tag > label:containsNC("' + field.val() + '")').parent().show();
    }
    else {
      $('li.tag', tagList).show();
    }
  });
});
