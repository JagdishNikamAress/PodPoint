'use strict';

(function () {

    StreamingClientResolverService.$inject = ['$q', 'StreamingAPIService', 'MstResolver', 'StateService', 'DeltaService'];

    angular.module('serviceExpert').factory('StreamingClientResolverService', StreamingClientResolverService);

    // this c'tor will function as our provider
    function StreamingClientResolverService($q, StreamingAPIService, MstResolver, StateService, DeltaService) {

        var latestCatchedEvent = -1;
        var StreamingChannels = ['ServicesTopic', 'AbsencesTopic', 'AssignedResourcesTopic', 'LivePositionsTopic', 'CapacitiesTopic', 'OptReqTopic', 'TimeDependencyTopic'];
        var replayExtensions = [];

        // register channel to push server
        function registerToPush(channel) {

            var currentChannel = '/topic/' + channel;
            var replayExtension = new cometdReplayExtension();
            replayExtension.setChannel(currentChannel);
            replayExtension.setReplay(latestCatchedEvent);
            $.cometd.registerExtension(channel, replayExtension);
            replayExtensions.push(replayExtension);
        }

        // connect to push server
        function connectToPush() {

            var metaHandshakeListener = $.cometd.addListener('/meta/handshake', function (message) {
                if (message.successful) {
                    console.log('Handshake successful!');
                    // console.log(message);
                    // console.log('setting replay: ' + latestCatchedEvent)

                    // set replay ext
                    for (var i = 0; i < StreamingChannels.length; i++) {
                        //replayExtensions[i].setReplay(latestCatchedEvent);
                        $.cometd.subscribe('/topic/' + StreamingChannels[i], StreamingAPIService.HandleNotification, function (subscribeReply) {

                            console.log(subscribeReply);

                            if (subscribeReply.successful) {}
                        });
                    }

                    //$.cometd.subscribe('/topic/MstCompletedChannel', MstResolver.handleCometdConnection);
                    StateService.setStreamingActiveState(true);
                } else {
                    StateService.setStreamingActiveState(false);
                    DeltaService.getDelta();
                    console.warn('Handshake! error: ' + message.error);
                }
            });

            // var metaSubscribeListener = $.cometd.addListener('/meta/disconnect', function(message) {  
            //     if (message.successful) {
            //         console.warn('disconnected! error: ' + message.error);
            //         console.log(message);
            //         StateService.setStreamingActiveState(false);
            //         DeltaService.getDelta();
            //     }
            //     else{
            //         StateService.setStreamingActiveState(true);
            //     }
            // });

            var metaSubscribeListener = $.cometd.addListener('/meta/connect', function (message) {
                if (!message.successful) {
                    console.warn('disconnected! error: ' + message.error);
                    console.log(message);
                    StateService.setStreamingActiveState(false);
                    DeltaService.getDelta();
                } else {
                    StateService.setStreamingActiveState(true);
                }
            });

            MstResolver.connectToPush();

            // $.cometd.init({
            //     url: window.location.protocol+'//'+window.location.hostname+ (null != window.location.port ? (':'+window.location.port) : '') +'/cometd/41.0/',
            //     requestHeaders: { Authorization: `OAuth ${sessionId}`},
            //     maxBackoff: 5000,
            //     logLevel: "debug"
            // });
        }

        // init connect
        function initStreaming() {
            try {

                if (StateService.getStreamingActiveState() == true) {

                    for (var i = 0; i < StreamingChannels.length; i++) {
                        registerToPush(StreamingChannels[i]);
                    }

                    connectToPush();
                } else {
                    MstResolver.connectToPush();
                }
            } catch (ex) {
                console.log(ex);
            }
        }

        // // init connect
        // (function() {

        //     try {

        //         if(StateService.getStreamingActiveState() == true){

        //             for (var i = 0; i < StreamingChannels.length; i++) {
        //                registerToPush(StreamingChannels[i]);
        //             }

        //             connectToPush();
        //         }

        //     } catch(ex) {
        //         console.log(ex);
        //     }

        // }());


        return {
            initStreaming: initStreaming
        };
    }
})();