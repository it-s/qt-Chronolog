import QtQuick 2.3

Image {
    id: page
    width: 320
    height: 480

    property int pageTransitionDuration: 300
    default property alias _contentChildren: pageContent.data

    signal show()
    signal shown()
    signal hide()
    signal hidden()

    function back() { app.goBack(); return true; }
    function menu() {return true;}

    Item
    {
        id: pageContent
        anchors.fill: parent
    }

//    Page shadowing effect
    Rectangle
    {
        id: pageOverlay
        color: "#000"
        anchors.fill: parent
        opacity: 0
        Behavior on opacity {NumberAnimation{duration: page.pageTransitionDuration}}
    }

    states: [
        State {
            name: "DISABLED"
            when: !page.enabled

            PropertyChanges {
                target: pageOverlay
                opacity: 1
            }
        }
    ]

}

