'use strict';

(function () {

    angular.module('MstResolver', []).provider('MstResolver', MstResolver);

    function MstResolver() {

        var config = {
            fslOperationRemoteAction: null,
            apiVersion: '41.0',
            fieldNames: {
                Initiator: 'Initiator__c',
                Request_Type: 'Request_Type__c',
                ResultText: 'ResultText__c'
            },
            autoConnect: true
        };

        this.setConfig = function (configObject) {
            return config = configObject;
        };

        this.$get = function ($q) {
            return MstResolverService($q, config);
        };

        this.$get.$inject = ['$q'];
    }

    // this c'tor will function as our provider
    function MstResolverService($q, config) {

        var fslOperations = {},
            cometdUnsubscribe = null,
            fslOperationReplies = {};

        var latestCatchedEvent = -1;

        var replayExtension = new cometdReplayExtension();
        replayExtension.setChannel('/topic/MstCompletedChannel');
        replayExtension.setReplay(latestCatchedEvent);
        $.cometd.registerExtension('myReplayExtensionName', replayExtension);

        // connect to push server
        function connectToPush() {

            var metaHandshakeListener = $.cometd.addListener('/meta/handshake', function (message) {
                if (message.successful) {
                    console.log('Handshake successful!');
                    // console.log(message);
                    // console.log('setting replay: ' + latestCatchedEvent)
                    // replayExtension.setReplay(latestCatchedEvent);
                    // set replay ext
                    $.cometd.subscribe('/topic/MstCompletedChannel', handleCometdConnection);
                } else {
                    console.warn('Handshake! error: ' + message.error);
                }
            });

            var metaSubscribeListener = $.cometd.addListener('/meta/connect', function (message) {
                if (!message.successful) {
                    console.warn('disconnected! error: ' + message.error);
                    // console.log(message);
                }
            });

            $.cometd.init({
                url: window.location.protocol + '//' + window.location.hostname + (null != window.location.port ? ':' + window.location.port : '') + '/cometd/' + config.apiVersion + '/',
                requestHeaders: { Authorization: 'OAuth ' + sessionId },
                maxBackoff: 5000,
                logLevel: "debug"
            });

            //cometdUnsubscribe = $.cometd.subscribe('/topic/MstCompletedChannel', handleCometdConnection);
            //$.cometd.subscribe('/meta/connect', function(m) { console.log(m);});
            //$.cometd.subscribe('/meta/disconnect', function(m) { console.log('dis'); console.log(m);});
        }

        // handling messages from cometd
        function handleCometdConnection(message) {

            // not relevant - deleted event
            if (message.data.event.type === 'deleted') {
                return;
            }

            console.info('message from stream, type: ' + message.data.event.type + ', replayId: ' + message.data.event.replayId + ', fslOp: ' + message.data.sobject.Id);

            // set latest replay event id in case the connection will drop
            latestCatchedEvent = message.data.event.replayId;

            // saving the message
            fslOperationReplies[message.data.sobject.Id] = message;

            // check if we already have promise
            var fslOp = fslOperations[message.data.sobject.Id];

            if (fslOp) {
                fslOp.deferred.resolve(message);
            }

            // // not relevant
            // if ((!fslOp && !fslOp.deferred) || (message.data.event.type === 'deleted')) {
            //     return;
            // }
            //
            // fslOperations[message.data.sobject.Id] = fslOp;
            //
            // if (config.fslOperationRemoteAction) {
            //
            //     Visualforce.remoting.Manager.invokeAction(config.fslOperationRemoteAction,
            //         fslOp.time, message.data.sobject.Id,
            //
            //         (res, ev) => {
            //
            //             // need to make sure there was no error in the fsl op, error is in result text
            //             if (ev.status && !res.fslOperation.fslOperation[config.fieldNames.ResultText]) {
            //                 res.fslOperation.result = JSON.parse(res.fslOperation.result);
            //
            //                 if (res.fslOperation.fslOperation[config.fieldNames.Request_Type] === 'Get Candidates') {
            //                     handleGetCandidatesString(res.fslOperation.result);
            //                 }
            //
            //                 if (res.fslOperation.fslOperation[config.fieldNames.Request_Type] === 'Appointment Booking') {
            //                     handleAppointmentBookingString(res.fslOperation.result.Slots);
            //                 }
            //
            //                 fslOp.deferred.resolve(res);
            //
            //             } else {
            //                 fslOp.deferred.reject(res);
            //             }
            //         },
            //
            //         { buffer: false, escape: false, timeout: 120000 }
            //     );
            //
            // } else {
            //     fslOp.deferred.resolve();
            // }
        }

        // parse get candaidates results
        function handleGetCandidatesString(result) {

            var candidates = result.ResourceIDToScheduleData;

            for (var candidate in candidates) {
                candidates[candidate].SchedulingOptions.forEach(function (option) {
                    option.Interval.Start = moment(option.Interval.Start).valueOf();
                    option.Interval.Finish = moment(option.Interval.Finish).valueOf();

                    for (var relatedKey in option.MSTOptions) {
                        option.MSTOptions[relatedKey].Interval.Start = moment(option.MSTOptions[relatedKey].Interval.Start).valueOf();
                        option.MSTOptions[relatedKey].Interval.Finish = moment(option.MSTOptions[relatedKey].Interval.Finish).valueOf();
                    }
                });
            }
        }

        // parse appointment booking results
        function handleAppointmentBookingString(slots) {
            slots.forEach(function (slot) {

                slot.Interval.Start = moment(slot.Interval.Start).valueOf();
                slot.Interval.Finish = moment(slot.Interval.Finish).valueOf();
            });
        }

        // signup to get updates (id = fsl operation id)
        function getUpdates(id) {

            fslOperations[id] = {
                time: new Date().getTime(),
                deferred: $q.defer(),
                mstPromise: $q.defer()
            };

            var fslOp = fslOperations[id];

            // when this promise will be resolved, run the remote action
            fslOperations[id].deferred.promise.then(function (message) {

                if (config.fslOperationRemoteAction) {

                    Visualforce.remoting.Manager.invokeAction(config.fslOperationRemoteAction, fslOp.time, message.data.sobject.Id, function (res, ev) {

                        // need to make sure there was no error in the fsl op, error is in result text
                        if (ev.status && !res.fslOperation.fslOperation[config.fieldNames.ResultText]) {
                            res.fslOperation.result = JSON.parse(res.fslOperation.result);

                            if (res.fslOperation.fslOperation[config.fieldNames.Request_Type] === 'Get Candidates') {
                                handleGetCandidatesString(res.fslOperation.result);
                            }

                            if (res.fslOperation.fslOperation[config.fieldNames.Request_Type] === 'Appointment Booking') {
                                handleAppointmentBookingString(res.fslOperation.result.Slots);
                            }

                            fslOp.mstPromise.resolve(res);
                        } else {
                            fslOp.mstPromise.reject(res.fslOperation.fslOperation[config.fieldNames.ResultText]);
                        }
                    }, { buffer: false, escape: false, timeout: 120000 });
                }
            });

            // we already got the reply, resolve the reply (function above will run)
            if (fslOperationReplies[id]) {
                fslOp.deferred.resolve(fslOperationReplies[id]);
                delete fslOperationReplies[id];
            }

            return fslOperations[id].mstPromise.promise;
        }

        // use delta style polling
        function pollFslOperationObjects() {

            var idsToCheck = [];

            for (var pId in fslOperations) {
                if (fslOperations[pId].promise.$$state.status === 0) {
                    idsToCheck.push(opId);
                }
            }

            // TODO: call to salesforce
        }

        // init connect
        (function () {

            try {

                if (config.autoConnect) {
                    connectToPush();
                }
            } catch (ex) {
                console.log(ex);
            }
        })();

        return {
            getUpdates: getUpdates,
            connectToPush: connectToPush,
            handleCometdConnection: handleCometdConnection
        };
    }
})();