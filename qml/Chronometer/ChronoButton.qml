import QtQuick 2.3

Image {
    id: chronoButton
    width: U.px(209)
    height: width
    clip: true
//    source: "../Assets/toggleButton.png"

    function play(){
        iconStop.opacity = 0;
        iconStop.scale = 0.3;
        iconPlay.opacity = 1;
        iconPlay.scale = 1;
        iconPause.opacity = 0;
        iconPause.scale = 0.3;
    }

    function stop(){
        iconStop.opacity = 1;
        iconStop.scale = 1;
        iconPlay.opacity = 0;
        iconPlay.scale = 0.3;
        iconPause.opacity = 0;
        iconPause.scale = 0.3;
    }

    function pause(){
        iconStop.opacity = 0;
        iconStop.scale = 0.3;
        iconPlay.opacity = 0;
        iconPlay.scale = 0.3;
        iconPause.opacity = 1;
        iconPause.scale = 1;
    }

    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    Image{
        id: iconStop
        width: U.px(94)
        height: width
        source: "../Assets/toggleButtonStop.png"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: 1
        scale: 1

        Behavior on opacity {NumberAnimation{}}
        Behavior on scale {NumberAnimation{}}
    }

    Image{
        id: iconPlay
        width: U.px(79)
        height: U.px(84)
        anchors.horizontalCenterOffset: U.px(5)
        source: "../Assets/toggleButtonRun.png"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: 0
        scale: 0.3

        Behavior on opacity {NumberAnimation{}}
        Behavior on scale {NumberAnimation{}}
    }

    Image{
        id: iconPause
        width: U.px(77)
        height: width
        source: "../Assets/toggleButtonPause.png"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: 0
        scale: 0.3

        Behavior on opacity {NumberAnimation{}}
        Behavior on scale {NumberAnimation{}}
    }

}
