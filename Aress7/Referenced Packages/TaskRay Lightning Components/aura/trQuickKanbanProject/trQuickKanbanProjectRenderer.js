({
  rerender: function(component, helper) {
    this.superRerender();
    //this is not a after rerender, we need to wait for the next tick
    window.setTimeout(
      $A.getCallback(
        function() {
          //Initialize check to see if we need to initialize dragula
          helper.initializeDragula(component, helper);
        }.bind(this)
      ),
      0
    );
  }
});