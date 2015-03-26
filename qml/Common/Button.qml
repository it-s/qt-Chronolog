import QtQuick 2.3

MouseArea {
    width: U.px(140)
    height: width

    property string type: "menu"
    property string text: ""

    onPressed: sound.soundButtonPress();
    scale: pressed? 0.8: 1
//    opacity: (enabled)?1:0.5

    Image{
        width: U.px(60)
        height: width
        anchors.verticalCenterOffset: (parent.text!="")?U.px(-15):0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "../Assets/"+type+".icon.png"
//        scale: parent.pressed?.1:1
//        Behavior on scale {NumberAnimation{duration: 250}}
    }
    Text{
        color: "#ddd"
        visible: (parent.text!="")
        text: parent.text
        anchors.bottomMargin: U.px(15)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: U.px(28)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
