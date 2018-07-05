({
  render: function(component, helper) {
    var progressArray = component.get('v.progressArray');
    // By default, after the component finished loading data/handling events,
    // it will call this render function this.superRender() will call the
    // render function in the parent component.
    var ret = this.superRender();

    // Calls the helper function to append the SVG icon
    helper.renderCircle(component, helper);
    return ret;
  },
  rerender: function(component, helper) {
    // By default, after the component finished loading data/handling events,
    // it will call this render function this.superRender() will call the
    // render function in the parent component.
    this.superRerender();

    // Calls the helper function to append the SVG icon
    helper.renderCircle(component, helper);
  }
});