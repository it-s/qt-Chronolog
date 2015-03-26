/*
-
- Worker script for History view.
-
*/

function loadHistoryFromDatabase(){
    database.setModelQuery("select * from history order by id desc");
}

function deleteHistoryItem(itemID){
    database.removeRecord(itemID);
}

function clearHistory(){
    database.clear();
}
