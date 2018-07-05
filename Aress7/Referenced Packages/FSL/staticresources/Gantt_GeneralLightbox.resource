'use strict';

(function () {

    GeneralLightbox.$inject = ['$rootScope', '$sce', '$compile', 'utils', 'StateService'];

    angular.module('serviceExpert').factory('GeneralLightbox', GeneralLightbox);

    function GeneralLightbox($rootScope, $sce, $compile, utils, StateService) {

        // create a new scope
        var $scope = null;

        // close lightbox from outside
        function closeLightboxFromOutside() {
            return $scope.closeLightbox();
        }

        function open(title, url) {

            if ($scope) {
                return;
            }

            // create new isolated scope
            $scope = $rootScope.$new(true);

            // page urls
            $scope.url = $sce.trustAsResourceUrl(url).toString();

            $scope.title = title;

            $scope.closeLightbox = closeLightbox;

            // add to body
            var lightboxDomElement = generateTemplate();
            lightboxDomElement.find('#ResourceLightbox').draggable({ handle: '#ResourceLightboxHeader' });
            lightboxDomElement.find('#ResourceLightbox').resizable({ minHeight: 560, minWidth: 940, maxWidth: 940, handles: "s" });
            angular.element('body').append(lightboxDomElement);

            // set lightbox to open
            StateService.setLightBoxStatus();

            // on destroy, remove DOM elements
            $scope.$on('$destroy', function () {
                return lightboxDomElement.remove();
            });

            // add ESC shortcut
            $scope.$on('keypress', function (broadcastData, e) {
                if (e.which == 27) {
                    $scope.$evalAsync($scope.closeLightbox);
                }
            });

            // compile
            $compile(lightboxDomElement)($scope);

            utils.safeApply($scope);
        }

        function closeLightbox() {
            $scope.killWatch && $scope.killWatch();
            StateService.setLightBoxStatus(false);
            $scope.$destroy();
            $scope = null;
        }

        function generateTemplate() {
            return angular.element('<div class="LightboxBlackContainer ng-cloack">\n                    <div class="LightboxContainer ng-cloak" id="ResourceLightbox">\n\n                        <div class="lightboxHeaderContainer lightbox-general" id="ResourceLightboxHeader">\n                            <svg ng-click="closeLightbox()" aria-hidden="true" class="slds-icon CloseLightbox">\n                                \u2028<use xlink:href="' + lsdIcons.close + '"></use>\n                            \u2028</svg>\n                            \n                            <h1 class="lightboxHeader" id="resourceName" ng-bind="title"></h1>\n                        </div>\n                        \n                        <iframe ng-src="{{ url }}" class="resourceLightboxIframe"></iframe>\n\n                    </div>\n                </div>');
        }

        // This will be our factory
        return {
            open: open,
            closeLightboxFromOutside: closeLightboxFromOutside
        };
    }
})();