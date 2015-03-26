import QtQuick 2.3

Item {
    width: U.px(420)
    height: width

    property int intensivity: 50

    Behavior on intensivity {NumberAnimation{duration: 500}}
    Behavior on opacity {NumberAnimation{duration: 500}}

    function step(){
        return width/rows.rowCount;
    }

    function coords(index){
        var y=Math.floor(index/rows.rowCount);
        var x=index-(y*rows.rowCount);
        return {'x':x,'y':y}
    }

    function computePosition(index,isX){
        return (isX?coords(index).x*step():coords(index).y*step());
    }

    function computeDistance(index){
        var w = rows.rowCount/2;
        var p = coords(index);
        p.x = ((w-Math.abs(w-p.x))/w)/2;
        p.y = ((w-Math.abs(w-p.y))/w)/2;
        return (p.x+p.y);
    }

    function computeSize(index){
        return computeDistance(index)*(rows.maxItemWidth*intensivity/100);
    }

    Repeater{
        id: rows
        property int rowCount: 9
        property int maxItemWidth: U.px(20)
        model:rowCount*rowCount
        Item{
            x: computePosition(index,true)+step()/2
            y: computePosition(index,false)+step()/2
            Rectangle{
               x:-width/2
               y:-width/2
                width: computeSize(index)
                height: width
                color: "#82efff"
                radius: width/2
                opacity: computeDistance(index)
            }
        }
    }

}
