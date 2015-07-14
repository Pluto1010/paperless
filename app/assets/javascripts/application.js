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
//= require jquery/dist/jquery
//= require jquery_ujs
//= require foundation
//= require jquery-zoom/jquery.zoom
//= require select2

//= require_tree .

/**
* Unifies event handling across browsers
*
* - Allows registering and unregistering of event handlers
* - Injects event object and involved DOM element to listener
*
* @author Mark Rolich <mark.rolich@gmail.com>
*/

$(function(){ $(document).foundation(); });

Akten = (function() {
  var actions = {};

  function register_action(page, action_func) {
    actions[page] = action_func;
  }

  function run(page) {
    if(typeof(actions[page]) !== 'function') {
      return;
    }

    actions[page]();
  }

  return {
    'action': register_action,
    'run': run
  }
})();

Akten.action('documents#index', function() {
  $('ul.tag-list input[type=checkbox]').click(function() {
    $(this).parents('form').submit();
  });
});

$(function(){
  Akten.run($('body').data('page'));
});

// $(document).on("submit", "form[data-turboform]", function(e) {
//     Turbolinks.visit(this.action+(this.action.indexOf('?') == -1 ? '?' : '&')+$(this).serialize());
//     return false;
// });
