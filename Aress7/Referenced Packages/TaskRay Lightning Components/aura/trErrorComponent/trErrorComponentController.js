({
  doInit: function(component) {
    var fadeOutTimeout = component.get('v.fadeOutAfter');
    if (fadeOutTimeout !== null) {
      fadeOutTimeout = fadeOutTimeout * 1000;
      //Set timeout to add the opacity animation class
      window.setTimeout(
        $A.getCallback(
          function() {
            if (component.isValid()) {
              $A.util.addClass(component, 'fade-out');
            }
          }.bind(this)
        ),
        fadeOutTimeout
      );
      window.setTimeout(
        $A.getCallback(
          function() {
            if (component.isValid()) {
              component.destroy();
            }
          }.bind(this)
        ),
        fadeOutTimeout + 1000
      );
    }
  }
});