import QtQuick 2.3

Item {

    property string value: ""

    function getCharacter(index){
        var c = value[index];
        return (c===":")?"a":
                          (c===undefined)?"0":c;
    }

    Row{

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: U.px(-30)
        Repeater{
            model: value.length
            Image{
                width: U.px(80)
                height: U.px(150)
                source: "../Assets/"+getCharacter(index)+".png"
            }
        }
    }
}
