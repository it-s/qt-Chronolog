import QtQuick 2.3
import Qt.labs.settings 1.0

import "Common"
import "Chronometer"

import "js/date_formater.js" as DateFormat
import "js/chronometer.js" as Script

Page {
    id: chronometer
    source: "Assets/bg.png"

    /*
    -
    - chronometerlication global variables and functions
    -
    */

    property int darknessFactor: 0
    property int deviceRotation: 0

    property bool handsFree: false
    property bool paused: false
    property bool running: false

    property double lastTimestamp: settings.lastTimestamp
    property double limitTimestamp: settings.limitTimestamp
    property double elapsedTimestamp: settings.elapsedTimestamp
    property double elapsedRunTime: settings.elapsedRunTime

    function takeSnapshot(save){
        var d = 0;
        if(isRuning()&&!isPaused()) d = getTotalRunningTime();
        else d = elapsedRunTime;

        if(save!==undefined){
            clockFaceTimer.showVisualSnapshot();
            toolbar.text = "<i>Last Snapshot<br>"+DateFormat.formatTimeStringAsDigitalNotation(d)+"</i>";
            var data = {
                date: new Date().getTime(),
                result: d,
                tags: ""
            }
            history.add(data);
        }
    }

    Settings {
        id: settings
        property double lastTimestamp: 0
        property double limitTimestamp: 0
        property double elapsedRunTime: 0
        property double elapsedTimestamp: 0
    }

    Component.onCompleted: {
        updateLimitDisplay();
        takeSnapshot();
    }

    Component.onDestruction: {
        settings.lastTimestamp = chronometer.lastTimestamp
        settings.limitTimestamp = chronometer.limitTimestamp
        settings.elapsedTimestamp = chronometer.elapsedTimestamp
        settings.elapsedRunTime = chronometer.elapsedRunTime
    }

    function back() { clear(); return true; }
    function menu() { app.goToPage("History"); return true;}

    /*
    -
    - Helper getter and setter functions
    -
    */

    function isHandsFree(){
        return handsFree;
    }

    function isRuning(){
        return running;
    }

    function isPaused(){
        return paused;
    }

    function isNotPaused(){
        return !paused;
    }

    function isNotRuning(){
        return !running;
    }

    function getTotalRunningTime(){
        return elapsedRunTime+elapsedTimestamp;
    }

    function updateTimestamp(){
        lastTimestamp = DateFormat.getCurrentTimestamp();
    }

    function updateElapsedTimestamp(){
        elapsedTimestamp = DateFormat.getTimeDifference(lastTimestamp,DateFormat.getCurrentTimestamp());
    }

    function clearTotalRunningTime(){
        elapsedRunTime = 0;
    }

    function updateTotalRunningTime(){
        elapsedRunTime += elapsedTimestamp;
    }

    function updateTimerDisplay(){
        clockFaceTimer.value = DateFormat.formatTimeStringAsDigitalNotation(getTotalRunningTime());
        var t = DateFormat.timestampToTime(getTotalRunningTime());
        dial.seconds = t.seconds;
        dial.minutes = t.minutes;
        dial.hours = t.hours;
    }

    function clearTimerDisplay(){
        clockFaceTimer.value = DateFormat.formatTimeStringAsDigitalNotation(0);
        dial.seconds = 0;
        dial.minutes = 0;
        dial.hours = 0;
    }

    function updateLimitDisplay(){
        var t = DateFormat.timestampToTime(limitTimestamp);
        dial.secondsLimit = t.seconds;
        dial.minutesLimit = t.minutes;
        dial.hoursLimit = t.hours;
    }

    function isTimeLimitReached(){
        if(limitTimestamp===0)return;
        var elapsedSeconds = Math.floor(getTotalRunningTime()/1000);
        var limitSeconds = Math.floor(limitTimestamp/1000);
        if(elapsedSeconds>=limitSeconds){
            stop();
            sound.soundAlarm();
        }
    }

    /*
    -
    - Process flow control functions
    -
    */

    function toggle(m){
        if(m===undefined) handsFree=true;
        else  handsFree=false;

        if(!isPaused()){
            paused = true;
            updateTotalRunningTime();
            takeSnapshot();
            sound.soundButtonPress();
            toggleButton.play();
        }else{
            updateTimestamp();
            paused = false;
            sound.soundButtonPress();
            toggleButton.pause();
            clockFaceTimer.bright();
        }
    }

    function stop(){
        handsFree = false;
        running = false;

        if(!paused)updateTotalRunningTime();
        paused = false;

        takeSnapshot();
        reset();

        //clearTimerDisplay();
        toggleButton.stop();
        clockFaceTimer.dim();

    }

    function start(m){
        clearTotalRunningTime();
        updateTimestamp();

        running = true;
        paused = false;

        if(m===undefined) handsFree=true;
        else  handsFree=false;

        sound.soundButtonPress();
        toggleButton.pause();
        clockFaceTimer.bright();
    }

    function reset(){
        lastTimestamp = 0;
        elapsedTimestamp = 0;
        updateTimerDisplay();
    }

    function clear() {
        chronometer.stop();
        chronometer.clearTimerDisplay();
    }

    /*
    -
    - The Loop
    -
    */

    Timer{
        id: msTimer
        repeat: true
        running: (chronometer.running&&!chronometer.paused)
        interval: 10

        onTriggered: {
            updateElapsedTimestamp();
            updateTimerDisplay();
            isTimeLimitReached();
        }
    }

    /*
    -
    - The Chronometer view
    -
    */

    Image {
        id: darkRoom
        anchors.fill: parent
        source: "Assets/dark.png"
        opacity: chronometer.darknessFactor/100
    }

    Image{
        source: "Assets/clockFace.png"
        width: U.px(622)
        height: width
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 1-(chronometer.darknessFactor/100)
        Image{
            smooth: true
            anchors.fill: parent
            source: "Assets/clockFaceDark.png"
            opacity: chronometer.darknessFactor/100
        }

    }

    Clock{
        id: dial
        rotation: 0
        seconds: 0
        secondsLimit: 0
        minutes: 0
        minutesLimit: 0
        hours: 0
        hoursLimit: 0
    }

    ChronoButton {
        id: toggleButton
    }

//    Compass {
//        id: compass

//        // Create a variable to hold azimuth
//        property double azimuth: 0

//        // Turn on the sensor
//        active: true

//        // Change sensor axis depending on 'userOrientation' property
////        axesOrientationMode: Compass.UserOrientation

//        onReadingChanged: { // Called when a new compass reading is available
//            compass.azimuth = reading.azimuth;
//        }
//    }

//    CompasDial{
////        rotation: -compass.azimuth
//    }

    MagnifyingGlass{
        id: sliderDisplay
        angle: sensor.getCurrentAngle()
        value: "0"
        opacity: sensor.dragging?1:0
    }


    Meter{
        id: clockFaceTimer
        width: U.px(632)
        height: U.px(150)
        anchors.top: parent.top
        anchors.topMargin: U.px(60)
        anchors.horizontalCenter: parent.horizontalCenter
        value: "00:00:00:000"
        flash: isPaused();
    }

//    FingerPrint{
//        x:sensor.mouseX-width/2
//        y:sensor.mouseY-width/2
//        opacity: sensor.pressed
//        intensivity: (sensor.pressed)?100:0
//    }

    /*
    -
    - Main screen sensor
    -
    */

    MouseArea{
        id:sensor
        anchors.fill: parent
        property bool dragging: false
        property int currentElement: -1
        property variant limits: [0,U.px(80),U.px(163),U.px(230),U.px(340)]

        function computeAction(){
            var a = Math.abs((parent.width/2)-mouseX);
            var b = Math.abs((parent.height/2)-mouseY);
            return Math.floor(Math.sqrt(a*a+b*b));
        }

        function getCurrentWidget(){
            var d = computeAction();
            for(var i=1;i<limits.length;i++){
                if(d>=limits[i-1]&&d<limits[i])return i;
            }
            return -1;
        }

        function getCurrentAngle(sectors){
            if(sectors===undefined) sectors=0;
            var deltaX = mouseX - (parent.width/2);
            var deltaY = mouseY - (parent.height/2);
            var angle = (Math.atan2(deltaY, deltaX) * 180 / Math.PI)+90;
            return Math.floor(((angle<0)?270+90-Math.abs(angle):angle)+(sectors/100));
        }

        function getCurrentSector(sectors){
            return Math.floor(getCurrentAngle(sectors)/360*sectors);
        }

        function draggedOutOfBounds(){
            return getCurrentWidget()===-1;
        }

        function detectCurrentWidget(){
            currentElement = getCurrentWidget();
        }

        function dragTimeLimiters(){
            var l = DateFormat.timestampToTime(limitTimestamp);
            if(currentElement===2){l.hours = getCurrentSector(12);sliderDisplay.value = l.hours; dragging = true;}
            if(currentElement===3){l.minutes = getCurrentSector(60);sliderDisplay.value = l.minutes; dragging = true;};
            if(currentElement===4){l.seconds = getCurrentSector(60);sliderDisplay.value = l.seconds; dragging = true;};

            if(draggedOutOfBounds()){sliderDisplay.value=":"}
            chronometer.limitTimestamp = DateFormat.timeToTimestamp(l);
            chronometer.updateLimitDisplay();
        }

        function restTimeLimiters(){
            var l = DateFormat.timestampToTime(limitTimestamp);
            if(currentElement===2)l.hours = 0;
            if(currentElement===3)l.minutes = 0;
            if(currentElement===4)l.seconds = 0;

            chronometer.limitTimestamp = DateFormat.timeToTimestamp(l);
            chronometer.updateLimitDisplay();
        }

        //--------------------[Simple start of the timer -> TAP]----------
        onClicked:{
            if(currentElement===1){
                if(chronometer.isRuning())chronometer.toggle();
                else chronometer.start();
            }
        }
        //--------------------[Simple start of the timer -> TAP]----------
        onPressAndHold:{
            if(chronometer.isHandsFree()&&chronometer.isRuning()&&!dragging)
                stop();
            else if(chronometer.isNotRuning()&&!dragging) chronometer.start(true);
//            else if(!chronometer.isHandsFree()&&chronometer.isRuning()&&chronometer.isPaused()&&!dragging) chronometer.toggle(true);
        }

        onReleased: {
            dragging = false;
            if(draggedOutOfBounds())
                restTimeLimiters();
            if(chronometer.isRuning()&&!chronometer.isPaused()&&!chronometer.isHandsFree()&&!dragging)
                chronometer.stop();
        }

        onPositionChanged:
            if(chronometer.isNotRuning()|| chronometer.isPaused())
                dragTimeLimiters();

        onPressed: detectCurrentWidget();
    }

    SnaphotWidget{
        anchors.top: parent.top
        anchors.topMargin: U.px(160)
        anchors.rightMargin: U.px(54)
        anchors.right: parent.right
        active: isRuning();

        onClicked: {
            sound.soundSnapshot();
            takeSnapshot(true);
        }
    }

    Toolbar{
        id: toolbar
        onResetPressed: clear()
    }

    Button{
        anchors.left: parent.left
        anchors.top: parent.top
        opacity: .3
        type: "help"
        onClicked: help.show()
    }

    Help {
        id: help
        source: "Assets/help01.jpg"
    }

}
