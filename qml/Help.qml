import QtQuick 2.3

Image {
    id: help
    width: 768
    height: 1280
    anchors.fill: parent
    opacity: 0

    function show(){
        help.state = "SHOW";
    }
    function hide(){
        help.state = "";
    }

    MouseArea{
        id: sensor
        enabled: false
        anchors.fill: parent
        onClicked: parent.hide()
    }
    states: [
        State {
            name: "SHOW"

            PropertyChanges {
                target: help
                opacity: 1
            }

            PropertyChanges {
                target: sensor
                enabled: true
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "SHOW"
            NumberAnimation {target: help;property: "opacity"; duration: 500;}
        },
        Transition {
            from: "SHOW"
            to: ""
            NumberAnimation {target: help;property: "opacity"; duration: 500;}
        }
    ]

}
