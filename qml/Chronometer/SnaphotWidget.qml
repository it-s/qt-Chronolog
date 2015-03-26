import QtQuick 2.3

MouseArea {
    id: snapshotWidget
    width: U.px(171)
    height: U.px(195)

    property bool active: false

    Image{
        smooth: true
        scale: (parent.active&&snapshotWidget.pressed)?0.1:(parent.active?1:(snapshotWidget.pressed?0.6:0.8))
        opacity: (parent.active)?1:.5
        transformOrigin: Item.TopRight
        anchors.fill: parent
        source: "../Assets/snapshot.png"
        Behavior on scale {NumberAnimation{ easing.type: Easing.OutQuad; duration: 500}}
        Behavior on opacity {NumberAnimation{}}
    }
}
