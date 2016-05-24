var globalX, globalY;
var globalXY = [globalX, globalY];
var globalZ;
var globalHands = [];

(function() {
    function getFingerPositions(frame) {
        // set up data array and other variables
        var data = [];
        var pos, i, len;
        var hands = [];

        for(h=0; h < frame.hands.length; h++){
            hands.push(h);
            globalHands = hands;
        }

        // loop over the frame's pointables
        for (i = 0, len = frame.pointables.length; i < len; i++) {
            // get the pointable and its position
            pos = frame.pointables[i].tipPosition;
            //separate into X,Y coordinates
            globalX = pos.x;
            globalY = pos.y;
            globalZ = pos.z;
            var globalXY = [globalX, globalY];
        }

        $("#x").html("X: " + globalX);
        $("#y").html("Y: " + globalY);
        $("#z").html("Z: " + globalZ);
        if (frame.gestures.length > 0) {
            // we check each gesture in the frame
            for (i = 0, len = frame.gestures.length; i < len; i++) {
                // and if one is the end of a swipe, we clear the canvas
                if (frame.gestures[i].type === 'swipe' &&
                 frame.gestures[i].state === 'stop' &&
                  frame.hands.length > 1
                  ) {
                    console.log("detected " + frame.hands.length + "hands in frame");
                    sketch.clearme();
                    console.log("canvas cleared.");
                }
            }
        }
    }
    Leap.loop({ enableGestures: true }, getFingerPositions);
})();
