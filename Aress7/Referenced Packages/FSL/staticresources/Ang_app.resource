'use strict';

(function () {

    // creating the angular app hi
    var app = angular.module('serviceExpert', ['uiGmapgoogle-maps', 'angularMoment', 'ui.bootstrap', 'chart.js', 'MstResolver']);

    app.run(['amMoment', function (amMoment) {
        amMoment.changeLocale(userLocale);
    }]);

    app.config(['$sceDelegateProvider', '$compileProvider', 'MstResolverProvider', function ($sceDelegateProvider, $compileProvider, MstResolverProvider) {

        // production
        if (!debugMode) {
            $compileProvider.debugInfoEnabled(false);
        }

        // set MST configs
        MstResolverProvider.setConfig({
            fslOperationRemoteAction: RemoteActions.getFslOperation,
            apiVersion: '41.0',
            fieldNames: fieldNames.FslOperation,
            autoConnect: false
        });

        // Allow same origin resource loads.
        $sceDelegateProvider.resourceUrlWhitelist(['self', 'https://**.force.com']);
    }]);
})();