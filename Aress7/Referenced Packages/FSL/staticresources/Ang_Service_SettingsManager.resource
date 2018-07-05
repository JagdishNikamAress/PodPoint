'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

(function () {

	angular.module('serviceExpert').factory('userSettingsManager', ['$q', function ($q) {
		var userSettingsManager = {};

		userSettingsManager.GetUserSettingsProperty = function (property) {
			return bootstrap.loadedUserSettings[property];
		};

		userSettingsManager.SetUserSettingsProperty = function (property, value) {
			var deferred = $q.defer();
			//bootstrap.loadedUserSettings[property] = JSON.parse(value); //ori - removed - no need for local save befor remote action?
			var type = typeof value === 'undefined' ? 'undefined' : _typeof(value);
			Visualforce.remoting.Manager.invokeAction(RemoteActions.SetUserSettingsProperty, property, value, type, function (setting, ev) {
				if (ev.result != null) {
					bootstrap.loadedUserSettings = JSON.parse(ev.result);
					deferred.resolve();
				}
			}, { buffer: false, escape: false, timeout: 120000 });
			return deferred.promise;
		};

		userSettingsManager.SetUserSettingProperties = function (propertiesAndValuesObject) {
			var deferred = $q.defer();
			for (var property in propertiesAndValuesObject) {
				var value = propertiesAndValuesObject[property];
				propertiesAndValuesObject[property] = value + ':' + (typeof value === 'undefined' ? 'undefined' : _typeof(value));
			}
			Visualforce.remoting.Manager.invokeAction(RemoteActions.SetUserSettingsProperties, propertiesAndValuesObject, function (setting, ev) {
				var str = JSON.parse(ev.result);

				if (!str.FailedLocations) {
					bootstrap.loadedUserSettings = str;
					deferred.resolve();
				} else {
					bootstrap.loadedUserSettings = str;
					deferred.reject(str);
				}
			}, { buffer: false, escape: false, timeout: 120000 });

			return deferred.promise;
		};

		userSettingsManager.SetUserSettingPropertiesPromise = function (propertiesAndValuesObject) {
			var deferred = $q.defer();
			userSettingsManager.SetUserSettingProperties(propertiesAndValuesObject);
			bootstrap.loadedUserSettings = JSON.parse(ev.result);

			return deferred.promise;
		};

		return userSettingsManager;
	}]);
})();