({
  organizeData: function(timeDataByTask, component) {
    var mondayEntries = [];
    var tuesdayEntries = [];
    var wednesdayEntries = [];
    var thursdayEntries = [];
    var fridayEntries = [];
    var saturdayEntries = [];
    var sundayEntries = [];
    var mondaySum = 0;
    var tuesdaySum = 0;
    var wednesdaySum = 0;
    var thursdaySum = 0;
    var fridaySum = 0;
    var saturdaySum = 0;
    var sundaySum = 0;

    for (var taskId in timeDataByTask) {
      var taskWithTimeItems = timeDataByTask[taskId];
      taskWithTimeItems.forEach(function(timeItem) {
        timeItem.TASKRAY__Hours__c =
          Math.round(timeItem.TASKRAY__Hours__c * 100) / 100;
        //round hours to 2 decimals, the + makes it an integer instead of a string.
        var roundedTimeItem = +timeItem.TASKRAY__Hours__c.toFixed(2);
        var dateObj = new Date(timeItem.TASKRAY__Date__c);
        var dateObjDayOfWeek = dateObj.getUTCDay();
        if (dateObjDayOfWeek == 1) {
          mondayEntries.push(timeItem);
          mondaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 2) {
          tuesdayEntries.push(timeItem);
          tuesdaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 3) {
          wednesdayEntries.push(timeItem);
          wednesdaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 4) {
          thursdayEntries.push(timeItem);
          thursdaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 5) {
          fridayEntries.push(timeItem);
          fridaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 6) {
          saturdayEntries.push(timeItem);
          saturdaySum += roundedTimeItem;
        } else if (dateObjDayOfWeek == 0) {
          sundayEntries.push(timeItem);
          sundaySum += roundedTimeItem;
        }
      });
    }
    var allDaysSums = [
      mondaySum.toFixed(2),
      tuesdaySum.toFixed(2),
      wednesdaySum.toFixed(2),
      thursdaySum.toFixed(2),
      fridaySum.toFixed(2),
      saturdaySum.toFixed(2),
      sundaySum.toFixed(2)
    ];
    // we want each of these components to have an array of visible entries to display when that day is clicked.
    component.set('v.sums', allDaysSums);

    //sort all the entry arrays for the days
    var dayEntries = [
      mondayEntries,
      tuesdayEntries,
      wednesdayEntries,
      thursdayEntries,
      fridayEntries,
      saturdayEntries,
      sundayEntries
    ];
    dayEntries.forEach(function(dayEntry) {
      var dayEntry = dayEntry.sort(function(entryA, entryB) {
        var entryADate = typeof entryA === 'undefined' &&
          typeof entryA.TASKRAY__Date__c === 'undefined'
          ? '0'
          : entryA.TASKRAY__Date__c;
        var entryBDate = typeof entryB === 'undefined' &&
          typeof entryB.TASKRAY__Date__c === 'undefined'
          ? '0'
          : entryB.TASKRAY__Date__c;
        if (entryADate > entryBDate) {
          return 1;
        }
        if (entryADate < entryBDate) {
          return -1;
        }
        if (entryADate === entryBDate) {
          if (entryA.TASKRAY__Hours__c < entryB.TASKRAY__Hours__c) {
            return -1;
          }
          if (entryA.TASKRAY__Hours__c > entryB.TASKRAY__Hours__c) {
            return 1;
          }
          if (entryA.TASKRAY__Hours__c === entryB.TASKRAY__Hours__c) {
            if (entryA.CreatedDate < entryB.CreatedDate) {
              return -1;
            }
            if (entryA.CreatedDate > entryB.CreatedDate) {
              return 1;
            }
          }
        }
      });
    });

    component.set('v.mondayEntries', mondayEntries);
    component.set('v.tuesdayEntries', tuesdayEntries);
    component.set('v.wednesdayEntries', wednesdayEntries);
    component.set('v.thursdayEntries', thursdayEntries);
    component.set('v.fridayEntries', fridayEntries);
    component.set('v.saturdayEntries', saturdayEntries);
    component.set('v.sundayEntries', sundayEntries);

    return null;
  },
  popErrorMessage: function(component, action) {
    var errors = action.getError();
    var msg = errors &&
      errors[0] &&
      errors[0].pageErrors &&
      errors[0].pageErrors[0] &&
      errors[0].pageErrors[0] &&
      errors[0].pageErrors[0].message
      ? errors[0].pageErrors[0].statusCode +
          ' ' +
          errors[0].pageErrors[0].message
      : '';
    if (msg == '') {
      if (typeof errors[0].message != 'undefined' && errors[0].message) {
        msg = errors[0].message;
      }
    }
    var showToast = $A.get('e.force:showToast');
    showToast.setParams({
      title: 'Error: ',
      message: 'Taskray encountered an error: ' + msg,
      type: 'error'
    });
    showToast.fire();
  },
  setPendingTaskId: function(component, taskId) {
    component.set('v.pendingTaskId', taskId);
  },
  addDays: function(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  },
  getStartDateOfWeek: function(fromDate) {
    // length of one day i milliseconds
    var dayLength = 24 * 60 * 60 * 1000;
    // Get the current date (without time)
    var currentDate = new Date(
      fromDate.getFullYear(),
      fromDate.getMonth(),
      fromDate.getDate()
    );
    // Get the current date's millisecond for this week
    var currentWeekDayMillisecond = currentDate.getDay() * dayLength;
    // subtract the current date with the current date's millisecond for this week
    var monday = new Date(
      currentDate.getTime() - currentWeekDayMillisecond + dayLength
    );
    if (monday > currentDate) {
      // It is sunday, so we need to go back further
      monday = new Date(monday.getTime() - dayLength * 7);
    }
    return monday;
  },
  formatDate: function(dateObj) {
    var dateFormat = 'DD MMM';
    var userLocaleLang = $A.get('$Locale.langLocale');
    return $A.localizationService.formatDate(
      dateObj,
      dateFormat,
      userLocaleLang
    );
  }
});