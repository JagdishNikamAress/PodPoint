({
  renderIcon: function(component) {
    var prefix = 'slds-';
    var svgns = 'http://www.w3.org/2000/svg';
    var xlinkns = 'http://www.w3.org/1999/xlink';
    var size = component.get('v.size');
    var name = component.get('v.name');
    var classname = component.get('v.class');
    var containerclass = component.get('v.containerClass');
    var category = component.get('v.category');
    var fillOverride = component.get('v.fillOverride');
    var isButton = component.get('v.isButton');

    var containerClassName = [
      prefix + 'icon_container',
      prefix + 'icon-' + category + '-' + name,
      containerclass
    ].join(' ');
    component.set('v.containerClass', containerClassName);

    var svgroot = document.createElementNS(svgns, 'svg');
    var iconClass = isButton === true
      ? prefix + 'button__icon '
      : prefix + 'icon ';
    var iconClassName = iconClass + prefix + 'icon--' + size + ' ' + classname;
    svgroot.setAttribute('aria-hidden', 'true');
    svgroot.setAttribute('class', iconClassName);
    svgroot.setAttribute('name', name);

    if (fillOverride !== '') {
      svgroot.style.fill = fillOverride;
    }

    // Add an "href" attribute (using the "xlink" namespace)
    var shape = document.createElementNS(svgns, 'use');
    var iconRoot = component.get('v.iconRoot');
    //We need to use the external icons so we can get them cross origin
    //This is only used when a component is used via lightning out
    if (window.forceCORSIcons) {
      iconRoot =
        'https://s3-us-west-1.amazonaws.com/taskrayassets/ltng-component-assets';
    }
    shape.setAttributeNS(
      xlinkns,
      'href',
      iconRoot + component.get('v.svgPath')
    );
    svgroot.appendChild(shape);

    var container = component.find('container').getElement();
    container.insertBefore(svgroot, container.firstChild);
  }
});