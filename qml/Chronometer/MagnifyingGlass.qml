import QtQuick 2.3

Item {
    id: item1
    width: U.px(293)
    height: width
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property alias angle:  pointer.rotation
    property alias value: text.value

    Behavior on opacity {NumberAnimation{duration: 250}}

    Rectangle{
        width: U.px(170)
        height:width
        color: "#000000"
        radius: width/2
        opacity: 0.800
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Image{
        id: pointer
        width: parent.width
        height: width
        smooth: true
        source: "../Assets/magniArrow.png"
    }

    BitmapText{
        width: U.px(200)
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        id: text

    }

    Image{
        width: U.px(206)
        height: width
        anchors.verticalCenterOffset: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../Assets/magniGlass.png"
    }
}
