'use strict';

(function () {

    angular.module('serviceExpert').directive('bulkActionsButton', BulkActionsButton);

    BulkActionsButton.$inject = [];

    function BulkActionsButton() {

        controllerFunction.$inject = ['$scope', 'servicesService', 'utils', 'bulkDispatchService', 'bulkUnscheduleService', 'ServiceSelectorService', 'optimizeLightboxService', 'bulkScheduleService', 'rdOptimizeLightboxService'];

        function controllerFunction($scope, servicesService, utils, bulkDispatchService, bulkUnscheduleService, ServiceSelectorService, optimizeLightboxService, bulkScheduleService, rdOptimizeLightboxService) {
            $scope.bulkActionsOrder = bulkActionsOrder;

            $scope.actionNames = {
                'Schedule': { name: customLabels.Schedule, icon: lsdIcons.calendar },
                'Dispatch': { name: customLabels.Dispatch, icon: lsdIcons.dispatch },
                'Optimize': { name: customLabels.Optimize, icon: lsdIcons.magicwand },
                'Flag-Unflag': { name: customLabels.Flag_Unflag, icon: lsdIcons.flag },
                'Unschedule': { name: customLabels.Unschedule, icon: lsdIcons.na }
            };

            $scope.checkHasCustomPermission = function (actionName) {
                if (utils.hasCustomPermission('Bulk_' + actionName) == undefined) return true;

                return utils.hasCustomPermission('Bulk_' + actionName);
            };

            $scope.openBulkAction = function (title) {
                switch (title) {
                    case 'Schedule':
                        bulkScheduleService.schedule(ServiceSelectorService.getSelected());
                        break;

                    case 'Dispatch':
                        bulkDispatchService.open();
                        break;

                    case 'Unschedule':
                        bulkUnscheduleService.open();
                        break;

                    case 'Optimize':
                        optimizeLightboxService.open();
                        break;

                    case 'Flag-Unflag':

                        var selected = ServiceSelectorService.getSelected();

                        for (var i = 0; i < selected.length; i++) {
                            servicesService.flagged[selected[i]] = !servicesService.flagged[selected[i]];
                        }

                        scheduler.updateView();

                        break;
                }
            };
        }

        var template = '<div id="quickActionsButtons">\n\t\t\t                    <div id="actionQuickFirst" class="truncate quickActionBtn" ng-show="bulkActionsOrder.first.length && checkHasCustomPermission(actionNames[bulkActionsOrder.first[0].title].name)" ng-click="openBulkAction(bulkActionsOrder.first[0].title)" title="{{actionNames[bulkActionsOrder.first[0].title].name}}">\n\t\t\t\t\t\t\t\t\t{{actionNames[bulkActionsOrder.first[0].title].name}}\n\t\t\t\t\t\t\t\t</div>\n\t                        \t<div id="actionQuickSecond"\n\t\t\t\t\t\t\t\t\t class="truncate quickActionBtn"\n\t\t\t\t\t\t\t\t\t ng-show="bulkActionsOrder.second.length && checkHasCustomPermission(actionNames[bulkActionsOrder.second[0].title].name)"\n\t\t\t\t\t\t\t\t\t ng-click="openBulkAction(bulkActionsOrder.second[0].title)"\n\t\t\t\t\t\t\t\t\t title="{{actionNames[bulkActionsOrder.second[0].title].name}}">{{actionNames[bulkActionsOrder.second[0].title].name}}</div>\n\t\t                    \t<div class="truncate" id="ActionButton" ng-show="bulkActionsOrder.dropdown.length" cs-toggle="MainActionContainer">\n                                    <span ng-show="(!bulkActionsOrder.first.length &&\n                                                   !bulkActionsOrder.second.length) ||\n                                                   (!checkHasCustomPermission(actionNames[bulkActionsOrder.first[0].title].name) &&\n                                                   !checkHasCustomPermission(actionNames[bulkActionsOrder.second[0].title].name))">\n                                           ' + customLabels.Actions + '\n                                    </span>\n                                    <i class="fa fa-caret-down"></i>\n\t\t                    \t</div>\n\t                    \t</div>\n\t                        <div id="MainActionContainer">\n\t\t\t                    <div class="truncate BulkActionMenuItem" ng-repeat="action in bulkActionsOrder.dropdown" ng-show="checkHasCustomPermission(actionNames[action.title].name)" ng-click="openBulkAction(action.title)">\n\t\t\t\t\t\t\t\t\t<svg aria-hidden="true" class="slds-icon mainActionIcon">\n\t\t\t\t\t\t\t\t\t\t\u2028<use xlink:href="{{actionNames[action.title].icon}}"></use>\n\t\t\t\t\t\t\t\t\t\u2028</svg>\n\t\t\t\t\t\t\t\t\t{{actionNames[action.title].name}}</div>\n\t                        </div>';

        return {
            restrict: 'E',
            template: template,
            scope: {},
            controller: controllerFunction
        };
    }
})();