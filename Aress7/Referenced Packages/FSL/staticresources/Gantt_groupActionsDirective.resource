'use strict';

(function () {
    angular.module('serviceExpert').directive('csGroupActions', ['$compile', function ($compile) {

        function linkFunc(scope, element, attrs) {

            var $moreMenu = $('<ul class="moreQuickActionsContainer"></ul>');

            var allQuickActions = $(element).parent().parent().children();
            var $lastChild, keepLooking;

            angular.element(element[0]).on('click', function (e) {

                e.stopPropagation();

                var last = $(allQuickActions).last();
                var first = $(allQuickActions).first();
                var firstTop = $(first).offset().top;
                var firstHeight = $(first).outerHeight(true);

                if ($moreMenu.hasClass('viewMoreActive')) {
                    $moreMenu.removeClass('viewMoreActive');
                    $moreMenu.empty();
                    $moreMenu.remove();
                    return;
                }

                if (needViewMore($(last), firstTop, firstHeight)) {

                    //runs through overflowing actions
                    for (var i = allQuickActions.length - 1; i > 1; i--) {
                        $lastChild = $(allQuickActions[i]);
                        keepLooking = needViewMore($lastChild, firstTop, firstHeight);

                        if (!keepLooking) {
                            continue;
                        } else {
                            var $li = $('<li></li>');
                            $lastChild.find('> div:first-child').clone().removeClass('quickActionGoLeft').addClass('menuQuickAction').css({ marginBottom: '0', border: 'none', width: '87%' }).appendTo($li);
                            $li.css({ display: 'block' }).appendTo($moreMenu);
                            $compile($li)(scope);
                        }
                    }

                    //reverse the list
                    $($moreMenu.children().get().reverse()).appendTo($moreMenu);

                    //add menu to btn
                    $(element).append($moreMenu);

                    //take care of view more click
                    $moreMenu.addClass('viewMoreActive');
                    $moreMenu.show();

                    var moreTop = $moreMenu.offset().top;
                    var moreHeight = $moreMenu.outerHeight(true);
                    if (!needViewMore($('#TaskListPagination'), moreTop, moreHeight)) {
                        $('#TaskListItems').animate({
                            scrollTop: $('#TaskListItems').scrollTop() + $moreMenu.children().length * 36
                        }, 500);
                    }
                }

                angular.element('body').on('mousedown', function (e) {
                    var classNames = ["moreQuickActionsBtn", "menuQuickAction", "fa-caret-down"];
                    for (var i = 0; i < classNames.length; i++) {
                        if (e.target.classList.contains(classNames[i]) || e.target.parentNode && e.target.parentNode.classList.contains(classNames[i])) return;
                    }

                    if ($moreMenu.hasClass('viewMoreActive')) {
                        $moreMenu.removeClass('viewMoreActive');
                        $moreMenu.empty();
                        $moreMenu.remove();

                        angular.element('body').off('mousedown');
                    }
                });
            });

            // this function checks if target element is on the same height as first element of ul
            function needViewMore(targetElement, firstTop, firstHeight) {
                return Math.ceil($(targetElement).offset().top) >= firstTop + firstHeight;
            }
        }

        return {
            restrict: 'A',
            link: linkFunc
            //scope: true
        };
    }]).directive('csLastAction', ['utils', 'SERVICE_STATUS', 'StateService', function (utils, SERVICE_STATUS, StateService) {

        function linkFunc(scope, element, attrs) {
            var $el = $(element);
            var service = scope.service;
            var actionName = attrs.csLastAction;

            switch (actionName) {
                case 'edit':
                    if ((service.pinned || !utils.hasCustomPermission('Reshuffle')) && (!service.isScheduled() || !(service.latitude || service.longitude) || !utils.hasCustomPermission('Group_Nearby')) && (service.pinned || service.status != SERVICE_STATUS.SCHEDULED) && !service.isScheduled() && (!StateService.isMapEnabled() || !service.latitude && !service.longitude)) {

                        $el.hide();
                    }
                    break;
                case 'reshuffle':
                    if ((!service.isScheduled() || !(service.latitude || service.longitude) || !utils.hasCustomPermission('Group_Nearby')) && (service.pinned || service.status != SERVICE_STATUS.SCHEDULED) && !service.isScheduled() && (!StateService.isMapEnabled() || !service.latitude && !service.longitude)) {

                        $el.hide();
                    }
                    break;
                case 'groupNearby':
                    if ((service.pinned || service.status != SERVICE_STATUS.SCHEDULED) && !service.isScheduled() && (!StateService.isMapEnabled() || !service.latitude && !service.longitude)) {

                        $el.hide();
                    }
                    break;
                case 'dispatch':
                    if (!service.isScheduled() && (!StateService.isMapEnabled() || !service.latitude && !service.longitude)) {

                        $el.hide();
                    }
                    break;
                case 'gantt':
                    if (!StateService.isMapEnabled() || !service.latitude && !service.longitude) {
                        $el.hide();
                    }
                    break;
            }
        }

        return {
            restrict: 'A',
            link: linkFunc
            //scope: true
        };
    }]);
})();