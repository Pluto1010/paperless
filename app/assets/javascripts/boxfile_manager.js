window.paperless = (function() {
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
