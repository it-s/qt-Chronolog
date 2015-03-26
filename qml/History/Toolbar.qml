import QtQuick 2.3
import "../Common"

import "../js/history.js" as Script

Image {
    width: parent.width
    height: U.px(140)
    source: "../Assets/toolbar.png"
    anchors.bottom: parent.bottom

    signal resetPressed

    Button{
        anchors.left: parent.left
        type: "back"
        text: "Back"
        onClicked: app.goBack();
    }

    Row{
        anchors.right: parent.right
        Button{
            id: button1
            type: "clear"
            text: "Clear"
            onClicked: resetPressed()
        }
    }
}

