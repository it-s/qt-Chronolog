import QtQuick 2.3

Item {
    id: rotator
    width: 100
    height: width

    property string indicatorType: "indHor"

    property int valueMax: 60
    property int value: 0

    function computeRotation(i){
        return 360/rotator.valueMax*rotator.value;
    }
    Behavior on opacity {NumberAnimation{duration: 250}}
    Item{
        id: repeaterWrap
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rotation: computeRotation()
        Behavior on rotation {RotationAnimation {duration: 500; easing.type: Easing.OutBack;direction: RotationAnimation.Shortest}}
        Image {
            property var scales: {'indHor': {'w':U.px(129),'h':U.px(69)},'indMin': {'w':U.px(153),'h':U.px(73)},'indSec': {'w':U.px(175),'h':U.px(74)},'selHor': {'w':U.px(129),'h':U.px(69)},'selMin': {'w':U.px(153),'h':U.px(73)},'selSec': {'w':U.px(175),'h':U.px(74)}}
            width: scales[rotator.indicatorType].w
            height: scales[rotator.indicatorType].h
            smooth: true
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../Assets/"+rotator.indicatorType+".png"
        }
    }

}
