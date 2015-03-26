import QtQuick 2.3

Item {
    id: meter
    width: 960
    height: 150
    opacity: 0.5

    property alias value: text.value

    property alias flash: flashAnimation.running

    function bright(){
        opacity = 1;
    }

    function dim(){
        opacity =0.5;
    }

    function showVisualSnapshot(){
        if(visualShapshot.running)visualShapshot.complete();
        visualShapshot.restart();
    }

    Behavior on opacity {NumberAnimation{}}

    BitmapText{
        id: text
        anchors.fill: parent
    }

    BitmapText{
        id: shadowText
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        value: "";
        opacity: 0
    }

    SequentialAnimation{
        id: flashAnimation
        loops: Animation.Infinite
        NumberAnimation { target: meter; property: "opacity"; duration: 250; to:0.6; easing.type: Easing.InOutQuad }
        NumberAnimation { target: meter; property: "opacity"; duration: 250; to:1; easing.type: Easing.InOutQuad }
    }

    SequentialAnimation{
        id: visualShapshot
        PropertyAction { target: shadowText; property: "value"; value: text.value }
        PropertyAction { target: shadowText; property: "y"; value:0 }
        ParallelAnimation{
            NumberAnimation { target: shadowText; property: "opacity"; duration: 250; to: 0.5; easing.type: Easing.InQuad }
            NumberAnimation { target: shadowText; property: "y"; duration: 250; to: 20; easing.type: Easing.InQuad }
        }
        ParallelAnimation{
            NumberAnimation { target: shadowText; property: "opacity"; duration: 250; to: 0; easing.type: Easing.OutQuad }
            NumberAnimation { target: shadowText; property: "y"; duration: 250; to: 40; easing.type: Easing.OutQuad }
        }
    }

}
