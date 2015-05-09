import QtQuick 2.3
import "../js/date_formater.js" as DateFormat

Rectangle {
    width: parent.width
    height: U.px(80)
    color: "#cfcfcf"

    Text{
        id: datePart
        color: "#888"
        anchors.fill: parent
        anchors.margins: U.px(20)
        font.pixelSize: U.px(32)
        font.family: "sans"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        text: DateFormat.getDateAsLocalsString(section)
    }
}
