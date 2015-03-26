import QtQuick 2.3
import "../Common"

Item {
    id: item1
    width: parent.width
    height: U.px(140)
    anchors.bottom: parent.bottom

    property alias text: resultPart.text

    signal resetPressed

    Button{
        id: reset
        anchors.left: parent.left
        type: "reset"
        onClicked: resetPressed()
//        {
//            chronometerView.stop();
//            chronometerView.clearTimerDisplay();
//        }
    }


        Text{
            id: resultPart
            color: "#eee"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            font.pixelSize: U.px(30)
            font.family: "sans"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            opacity: 0

            SequentialAnimation{
                id: flashText
                loops: 3
                NumberAnimation { target: resultPart; property: "opacity"; duration: 300;to:1; easing.type: Easing.InQuad }
                PauseAnimation {duration: 500}
                NumberAnimation { target: resultPart; property: "opacity"; duration: 300;to:0.5; easing.type: Easing.OutQuad }
            }

            onTextChanged: {
                if(flashText.running)flashText.complete();
                flashText.restart();
            }

            Behavior on opacity {NumberAnimation{}}
        }

    Button{
        id: list
        anchors.right: parent.right
        onClicked: app.goToPage("History")
    }
}
