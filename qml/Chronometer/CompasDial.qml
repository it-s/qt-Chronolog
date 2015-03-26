import QtQuick 2.3

Item{
    id: compas
    width: U.px(860)
    height: width
    smooth: true
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    Image{
        smooth: true
        anchors.fill: parent
        source: "../Assets/compasDark.png"
        opacity: app.darknessFactor/100
    }
    Image{
        smooth: true
        anchors.fill: parent
        source: "../Assets/compas.png"
    }
}
