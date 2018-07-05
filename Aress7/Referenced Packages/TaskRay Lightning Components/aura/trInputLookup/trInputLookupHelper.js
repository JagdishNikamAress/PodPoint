({
  //typeahead already initialized
  typeaheadInitStatus: {},
  //"old value" to trigger reload on "v.value" change
  typeaheadOldValue: {},
  /*
        Creates the typeahead component using RequireJS, jQuery, Bootstrap and Bootstrap Typeahead
    */
  createTypeaheadComponent: function(component) {
    var self = this;
    var globalId = component.getGlobalId();
    var inputElement = $('[id="' + globalId + '_typeahead"]');
    //init the input element
    $A.run(function() {
      inputElement.val(component.get('{!v.nameValue}'));
    });
    //handles the change function
    inputElement.keyup(function() {
      $A.getCallback(function() {
        if (inputElement.val() !== component.get('v.nameValue')) {
          component.set('v.nameValue', inputElement.val());
          component.set('v.value', null);
        }
      });
    });
    //inits the typeahead
    inputElement
      .typeahead(
        {
          hint: false,
          highlight: true,
          minLength: 2
        },
        {
          name: 'objects',
          displayKey: 'value',
          source: self.substringMatcher(component)
        }
      )
      .bind(
        'typeahead:selected',
        $A.getCallback(function(e, suggestion) {
          var appEvent = $A.get('e.TASKRAY_LTNG:trGenericAppEvent');
          if (appEvent) {
            appEvent.setParams({
              actionType: 'typeaheadSelected',
              payload: {
                target: 'TIME_ENTRY_ADD_TASK',
                selectedItemId: suggestion.id
              }
            });
            appEvent.fire();
          }
          component.set('v.value', suggestion.id);
          component.set('v.nameValue', suggestion.value);
        })
      );
  },
  /*
     * Method used by the typeahead to retrieve search results
     */
  substringMatcher: function(component) {
    //usefull to escape chars for regexp calculation
    function escapeRegExp(str) {
      return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
    }
    return function findMatches(q, cb) {
      q = escapeRegExp(q);
      var action = component.get('c.searchSObject');
      action.setParams({
        type: component.get('v.type'),
        searchString: q
      });
      action.setCallback(this, function(a) {
        if (a.error && a.error.length) {
          return $A.error('Unexpected error: ' + a.error[0].message);
        }
        var result = a.getReturnValue();
        var substrRegex;
        // an array that will be populated with substring matches
        var matches = [];
        // regex used to determine if a string contains the substring `q`
        var substrRegex = new RegExp(q, 'i');
        var strs = JSON.parse(result);
        // iterate through the pool of strings and for any string that
        // contains the substring `q`, add it to the `matches` array
        $.each(strs, function(i, str) {
          if (substrRegex.test(str.value)) {
            // the typeahead jQuery plugin expects suggestions to a
            // JavaScript object, refer to typeahead docs for more info
            matches.push({ value: str.value, id: str.id });
          }
        });
        if (!strs || !strs.length) {
          $A.run(function() {
            component.set('v.value', null);
          });
        }
        cb(matches);
      });
      $A.run(function() {
        $A.enqueueAction(action);
      });
    };
  },
  /*
     * Method used on initialization to get the "name" value of the lookup
     */
  loadFirstValue: function(component) {
    //this is necessary to avoid multiple initializations (same event fired again and again)
    if (this.typeaheadInitStatus[component.getGlobalId()]) {
      return;
    }
    this.typeaheadInitStatus[component.getGlobalId()] = true;
    this.loadValue(component);
  },
  /*
     * Method used to load the initial value of the typeahead
     * (used both on initialization and when the "v.value" is changed)
     */
  loadValue: function(component, skipTypeaheadLoading) {
    this.typeaheadOldValue[component.getGlobalId()] = component.get('v.value');
    var action = component.get('c.getCurrentValue');
    var self = this;
    action.setParams({
      type: component.get('v.type'),
      value: component.get('v.value')
    });
    action.setCallback(this, function(a) {
      if (a.error && a.error.length) {
        return $A.error('Unexpected error: ' + a.error[0].message);
      }
      var result = a.getReturnValue();
      component.set('v.isLoading', false);
      component.set('v.nameValue', result);
      if (!skipTypeaheadLoading) self.createTypeaheadComponent(component);
    });
    $A.enqueueAction(action);
  }
});