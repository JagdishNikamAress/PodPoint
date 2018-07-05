({
  init: function(component) {
    var ctx = component.getElement();
    component.message = "Finding ...";
    component.timer = {};
    component.engine = new Bloodhound({
      datumTokenizer: function (datum) {
        return Bloodhound.tokenizers.whitespace(datum.value);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      identify: function(obj) { return obj.id; }
    });
    component.typeahead = $('.typeahead', ctx).typeahead({
      hint: true,
      highlight: true,
      minLength: 2
    },
    {
      source: component.engine,
      display: "value",
      templates: {
        empty: function(context) {
          //console.log(context);
          return [
            "<div class='empty-message'>",
            component.message,
            "</div>"
            ].join("\n"); },
            suggestion: function(data){
              var icon = "/img/icon/tasks16.png";
              switch (data.sobjectType) {
                case "Lead": icon = "/img/icon/leads16.png"; break;
                case "Account": icon = "/img/icon/accounts16.png"; break;
                case "Contact": icon = "/img/icon/contacts16.png"; break;
                case "Opportunity": icon = "/img/icon/opportunities16.png"; break;
                case "User": icon = "/img/icon/profile16.png"; break;
              }
              return "<p><img src='" + icon + "'/> <strong> " + data.value + "</strong></p>";
            }
          }
        }).bind("typeahead:selected", function(obj, datum, name) {
            var selectionEvent = $A.get("e.lookup:finderEvt");
            selectionEvent.setParams({
              "selected": datum,
              "id": datum.id,
              "value": datum.value
            });
            selectionEvent.fire();
            datum = datum.value;
        });
      },
      query: function(component) {
        var self = this;
        var value = component.typeahead.val();
        clearTimeout(component.timer);
        component.engine.search(value, function(match){
          component.message = "Finding ...";
          if(value !== "" && value.length > 1 && match.length === 0) {
            self.getSelection(component, value).then(
              function(selections) {
                //component.message = " found";
                component.engine.add(selections);
                if(selections.length > 0) {
                  var val = component.typeahead.val();
                  component.typeahead.typeahead("val", "").typeahead("val", val);
                }
              },
              function(err) {
                console.log(err);
                //component.message = "No results found";
              }
            );
          }}
        );
    },
    getSelection: function(component, q) {
      return new Promise( function (resolve, reject) {
        //var sObjectType = component.get("v.sObjectType");
        //var sObjectField = component.get("v.sObjectField");
        var action = component.get("c.getOptions");
        action.setParams({
            "term": q,
            "limitSize": "20"
        });
        var callback = function(a) {
            var state = a.getState();
            var suggestions = [];
            if (state === "SUCCESS") {
                a.getReturnValue().forEach(function(x) {
                x.forEach(function(s) {
                    suggestions.push({"id": s.Id,
                                      "sobjectType": s.sobjectType,
                                      "value": secureFilters.html(s.Name)});
                  });
              });
            } else if (state === "ERROR") {
              var errors = a.getError();
              if (errors) {
                $A.logf("Errors", errors);
                if (errors[0] && errors[0].message) {
                  $A.error("Error message: " + errors[0].message);
                }
              }
            } else {
              $A.error("Unknown error");
            }
            resolve (suggestions);
        };
		action.setCallback(this, callback);
      $A.enqueueAction(action);
      component.timer = window.setTimeout(function () {
        $A.run(function() {
          component.message = "No results found";
          var val = component.typeahead.val();
          component.typeahead.typeahead("val", "").typeahead("val", val)
        });
      }, 5000);
    component.message = "Finding ...";
  });
}
})