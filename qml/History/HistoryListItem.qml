import QtQuick 2.3
import QtQuick.Layouts 1.1

import "../js/history.js" as Script
import "../js/date_formater.js" as DateFormat

Rectangle {
    id: historyListItem
    width: parent.width
    height: U.px(180)
    color: "#eee"

    opacity: 1-(x/width)

    Behavior on x {NumberAnimation{duration:300}}

    RowLayout{
        anchors.fill: parent
        anchors.margins: U.px(60)
        spacing: U.px(60)
        Text{
            id: datePart
            width: U.px(120)
            color: "#888"
            smooth: true
            wrapMode: Text.WordWrap
            font.pixelSize: U.px(42)
            font.family: "sans"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            text: DateFormat.getDateAsStackedCalendar(date)
        }
        Text{
            id: resultPart
            color: "#555"
            smooth: true
            font.pixelSize: U.px(74)
            font.family: "sans"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true
            text: DateFormat.formatTimeStringAsDigitalNotation(result)
        }
    }

    Rectangle{
        width: parent.width
        height: 1
        color: "#ccc"
        anchors.bottom: parent.bottom
    }

    MouseArea {
        id: sensor
        anchors.fill: parent
        drag.target: historyListItem
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: parent.width
        onReleased: {
            if(historyListItem.x>historyListItem.width*0.5){
                die.start();
            }else historyListItem.x=0;
        }
    }

    SequentialAnimation{
        id: die
        NumberAnimation { target: historyListItem; property: "height"; to: 0; duration: 250;}
        ScriptAction {script: history.remove(ID);}
    }


}
