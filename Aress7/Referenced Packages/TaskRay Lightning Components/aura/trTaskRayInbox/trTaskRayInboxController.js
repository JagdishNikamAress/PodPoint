({
  doInit: function(component, event, helper) {},
  runConfetti: function(component) {
    component.set('v.showConfetti', true);
    window.setTimeout(
      $A.getCallback(
        function() {
          component.set('v.showConfetti', false);
        }.bind(this)
      ),
      6000
    );
  },
  toggleShowOverdueTasks: function(component) {
    component.set('v.showOverdueTasks', !component.get('v.showOverdueTasks'));
  }
});