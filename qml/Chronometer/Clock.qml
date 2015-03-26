import QtQuick 2.3

Item{
    id: clockFace
    width: U.px(622)
    height: width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    property alias seconds: clockFaceSec.value
    property int secondsLimit: 0
    property alias minutes: clockFaceMin.value
    property int minutesLimit: 0
    property alias hours: clockFaceHor.value
    property int hoursLimit: 0

    rotation: -app.deviceRotation

    Rotator{
        id: clockFaceSec
        width: U.px(626)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "indSec"

        valueMax: 60
    }

    Rotator{
        id: clockFaceSecLimit
        width:clockFaceSec.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "selSec"

        valueMax: 60
        value: (secondsLimit<1)?0:secondsLimit
        opacity: (secondsLimit<1)?0:1
    }

    Rotator{
        id: clockFaceMin
        width:U.px(486)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "indMin"

        valueMax: 60
    }

    Rotator{
        id: clockFaceMinLimit
        width:clockFaceMin.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "selMin"

        valueMax: 60
        value: (minutesLimit<1)?0:minutesLimit
        opacity: (minutesLimit<1)?0:1
    }

    Rotator{
        id: clockFaceHor
        width: U.px(327)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "indHor"

        valueMax: 12
    }

    Rotator{
        id: clockFaceHorLimit
        width:clockFaceHor.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        indicatorType: "selHor"

        valueMax: 12
        value: (hoursLimit<1)?0:hoursLimit
        opacity: (hoursLimit<1)?0:1
    }
}
