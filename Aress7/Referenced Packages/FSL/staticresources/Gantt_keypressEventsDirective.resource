'use strict';

/*
	Keypress events handler
	Only keys that registered on "registeredKeys" will result in a broadcast
*/

(function () {

	angular.module('serviceExpert').directive('keypressEvents', ['$rootScope', function ($rootScope) {

		var registeredKeys = [13, 16, 18, 27, 37, 38, 39, 40, 48, 49, 50, 51, 55, 69, 70, 73, 77, 79, 83, 84, 85, 87, 90, 96, 97, 98, 99, 103];

		return {
			restrict: 'C',
			link: function link() {
				angular.element('body').bind('keydown', function (e) {

					// broadcast only if we registered the key
					if (registeredKeys.indexOf(e.which) > -1) $rootScope.$broadcast('keypress', e);else e.stopPropagation();
				});
			}
		};
	}]);
})();