.pragma library
Qt.include("string_formater.js")
/*
-
- Date formating code
-
*/

function getTimeObject(){
    return {'hours':0,'minutes':0,'seconds':0,'miliseconds':0};
}

function getCurrentTimestamp(){
    return new Date().getTime();
}

function timestampToTime(ts){
    var time = getTimeObject();
    if(ts===0)return time;
    var t = Math.floor(ts/1000);
    time.hours = (Math.floor(t/3600));
    time.minutes = (Math.floor(t/60)%60);
    time.seconds = (t%60);
    time.miliseconds = ((ts).toString().substr(-3))*1;
    return time;
}

function timeToTimestamp(t){    
    return (t.hours*3600+t.minutes*60+t.seconds)*1000+t.miliseconds;
}

function getMonthByNumber(n){
    var month = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
    return month[n];
}

function formatTimeStringAsDigitalNotation(s){
    var d = timestampToTime(s*1); //Time has to be a number
    return zeroFill(d.hours,2)+":"+zeroFill(d.minutes,2)+":"+zeroFill(d.seconds,2)+":"+zeroFill(Math.floor(d.miliseconds),3)
}

function getDateAsLocalsString(date,isUnixTime){
    if(isUnixTime!==undefined)date*=1000;//Convert unix time stamp to js timestamp
    var d = new Date(date*1); //Date has to be a number
    return d.toDateString()
}

function getDateAsStackedCalendar(date,isUnixTime){
    if(isUnixTime!==undefined)date*=1000;//Convert unix time stamp to js timestamp
    var d = new Date(date*1); //Date has to be a number
    return "<small>" + getMonthByNumber(d.getMonth())+d.getDate()+"</small><br><b>"+d.getFullYear()+"</b>";
}

function getTimeDifference(date1,date2){
    return Math.abs(date2-date1);
}
