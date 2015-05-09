import QtQuick 2.3
import QtQuick.Dialogs 1.2
import "Common"
import "History"

import "js/date_formater.js" as DateFormat
//import "js/history.js" as Script

Page {
    id: history
    fillMode: Image.Tile

    source: "Assets/vichy.png"

    function clarHistory(){
        if(!listCearing.running&&historyList.count>0)listCearing.start();
    }

    Text{
        color: "#888"
        smooth: true
        font.pixelSize: U.px(32)
        font.family: "sans"
        text: "History is empty"
        anchors.top: parent.top
        anchors.topMargin: U.px(120)
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: historyList.count===0?1:0;
        Behavior on opacity {NumberAnimation{}}
    }

    ListView {
        id: historyList
        clip: true
        anchors.bottomMargin: U.px(140)
        anchors.fill: parent
        model: history
        delegate: HistoryListItem {
            itemID: id
            date: DateFormat.getDateAsStackedCalendar(date,true)
            result: DateFormat.formatTimeStringAsDigitalNotation(result)
            tags: tags
        }

        section.property: "date"
        section.delegate: HistoryListHeading{
            field1: DateFormat.getDateAsLocalsString(section)
        }

    }

    HistoryViewShadows{
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
    }

    Toolbar{
        id: toolbar
        onResetPressed: clearDialog.open()
   }

    Button{
        anchors.left: parent.left
        anchors.top: parent.top
        opacity: 0.7
        type: "helpb"
        onClicked: help.show()
    }

    Help{
        id: help
        source: "Assets/help02.jpg"
    }

    MessageDialog {
        id: clearDialog
        icon: StandardIcon.Warning
        title: qsTr("Chronolog")
        text: qsTr("Do you want to clear your history, erasing all your saved records?")
        standardButtons: StandardButton.Cancel | StandardButton.Ok
        onAccepted: history.clar()
    }

}
