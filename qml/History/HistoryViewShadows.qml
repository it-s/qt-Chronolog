import QtQuick 2.3

Item {
    width: 768
    height: 1280
    Image{
        width:parent.width
        height: U.px(15)
        anchors.top: parent.top
        source: "../Assets/shadow.top.png"
    }
    Image{
        width:parent.width
        height: U.px(15)
        anchors.bottom: parent.bottom
        source: "../Assets/shadow.bottom.png"
    }
}
