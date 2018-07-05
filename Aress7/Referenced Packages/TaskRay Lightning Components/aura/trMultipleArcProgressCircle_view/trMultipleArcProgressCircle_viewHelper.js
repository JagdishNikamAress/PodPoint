({
  renderCircle: function(component, helper) {
    var svgns = 'http://www.w3.org/2000/svg';
    // var xlinkns = "http://www.w3.org/1999/xlink";
    var stroke = 20;
    var circleSize = 60;
    var canvasSize = stroke + circleSize;
    var x = canvasSize / 2;
    var y = canvasSize / 2;

    var progressArray = component.get('v.progressArray');
    if (!progressArray) {
      return;
    }

    var svgroot = document.createElementNS(svgns, 'svg');
    var paths = [];
    var accumulatedPercentage = 0;
    if (progressArray.length == 1) {
      svgroot.setAttribute('height', canvasSize + 'px');
      svgroot.setAttribute('width', canvasSize + 'px');
      var circleInsideColor = component.get('v.mountedInProjectRow')
        ? '#f1f3f7'
        : 'white';
      var circle = document.createElementNS(svgns, 'circle');
      circle.setAttribute('cx', canvasSize / 2);
      circle.setAttribute('cy', canvasSize / 2);
      circle.setAttribute('r', '30');
      circle.setAttribute('stroke', progressArray[0].color);
      circle.setAttribute('stroke-width', '18');
      circle.setAttribute('fill', circleInsideColor);
      svgroot.appendChild(circle);
    } else {
      progressArray.forEach(function(progressObj, index) {
        var progressPath = document.createElementNS(svgns, 'path');
        var percentage = progressObj.percentage;
        if (index == progressArray.length - 1) {
          percentage = 100 - accumulatedPercentage;
        }
        var color = progressObj.color;
        var arcDescribe = helper.generateBarPath(
          x,
          y,
          circleSize,
          percentage,
          accumulatedPercentage
        );
        progressPath.setAttribute('d', arcDescribe);
        progressPath.setAttribute('stroke', color);
        progressPath.setAttribute('stroke-width', '20');
        progressPath.setAttribute('fill', 'none');
        svgroot.appendChild(progressPath);
        accumulatedPercentage = accumulatedPercentage + percentage;
      });
    }

    svgroot.setAttribute('height', canvasSize + 'px');
    svgroot.setAttribute('width', canvasSize + 'px');

    var container = component.find('container').getElement();
    container.innerHTML = '';
    container.insertBefore(svgroot, container.firstChild);
  },
  generateBarPath: function(x, y, size, percentage, percentageOffset) {
    //Source: http://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
    function polarToCartesian(centerX, centerY, radius, angleInDegrees) {
      var angleInRadians = (angleInDegrees - 90) * Math.PI / 180.0;

      return {
        x: centerX + radius * Math.cos(angleInRadians),
        y: centerY + radius * Math.sin(angleInRadians)
      };
    }

    function describeArc(x, y, radius, startAngle, endAngle) {
      var start = polarToCartesian(x, y, radius, endAngle);
      var end = polarToCartesian(x, y, radius, startAngle);

      var arcSweep = endAngle - startAngle <= 180 ? '0' : '1';

      var d = [
        'M',
        start.x,
        start.y,
        'A',
        radius,
        radius,
        0,
        arcSweep,
        0,
        end.x,
        end.y
      ].join(' ');

      return d;
    }
    //Math basis = cross multiplying
    //  100%         pct %
    //  ---     =    ---
    //  360deg       x deg
    var startDegree = 360 * percentageOffset / 100;
    var endDegree = 360 * (percentageOffset + percentage) / 100;
    return describeArc(x, y, size / 2, startDegree, endDegree);
  }
});