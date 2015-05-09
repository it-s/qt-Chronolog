#include <QDebug>
#include <QSettings>

#include "history.h"


History::History(QObject *parent) :
    QAbstractListModel(parent)
{
    mDataRoles[ID] = "ID";
    mDataRoles[SectionRole] = "section";
    mDataRoles[DateRole] = "date";
    mDataRoles[ResultRole] = "result";
    mDataRoles[TagsRole] = "tags";

    QSettings mSettings;
    mNextID = mSettings.value("nextID", 0).toInt();
    int size = mSettings.beginReadArray("history");
    for (int i = 0; i < size; ++i) {
        mSettings.setArrayIndex(i);
        HistoryItem item;
        item.ID = mSettings.value("ID").toInt();
        item.result = mSettings.value("result").toString();
        item.date = mSettings.value("date").toString();
        item.tags = mSettings.value("tags").toString();
        mData.append(item);
    }
    mSettings.endArray();
    mDataChanged = false;
}

void History::synch()
{
    QSettings mSettings;
    mSettings.setValue("nextID", mNextID);
    mSettings.beginWriteArray("history", mData.count());
    for (int i = 0; i < mData.size(); ++i) {
        mSettings.setArrayIndex(i);
        mSettings.setValue("ID", mData.at(i).ID);
        mSettings.setValue("result", mData.at(i).result);
        mSettings.setValue("date", mData.at(i).date);
        mSettings.setValue("tags", mData.at(i).tags);
    }
    mSettings.endArray();
}

int History::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    else
        return mData.size();
}

QVariant History::data(const QModelIndex &index, int role) const
{
    QVariant result;
    QString date;

     //qDebug() << Q_FUNC_INFO << index << role;

     if (index.isValid()) {
         int row = index.row();
         if (row >= 0 && row < mData.size()) {
             const HistoryItem &item = mData[row];
             switch(role) {
             case ID:
                 result = item.ID;
                 break;
             case SectionRole:
                 date = item.date;
                 date.replace(7,6,"000000");
                 result = date.replace(7,6,"000000");
                 break;
             case ResultRole:
                 result = item.result;
                 break;
             case DateRole:
                 result = item.date;
                 break;
             case TagsRole:
                 result = item.tags;
                 break;
             }
         }
     }

     return result;
}

QVariantMap History::get(const int ID)
{
    return (QVariantMap) mData[findElementIndexByID(ID)];
}

void History::set(const int ID, const QVariantMap &v)
{
    HistoryItem &item = mData[findElementIndexByID(ID)];
    item = v;
    mDataChanged = true;
}

void History::add(const QVariantMap &v)
{
    qDebug("Add row");
    HistoryItem item;
    beginInsertRows(QModelIndex(), mData.count(), mData.count());
    item = v;
    item.ID = mNextID;
        mNextID++;

    mData.append(item);
    endInsertRows();
    mDataChanged = true;
}

void History::remove(const int ID)
{
    qDebug("Remove row");
    int index = findElementIndexByID(ID);
    beginRemoveRows(QModelIndex(),index, index);
    mData.removeAt(index);
    endRemoveRows();
    mDataChanged = true;
}

void History::clear()
{
    qDebug("Remove all");
    beginRemoveRows(QModelIndex(),0, mData.count() - 1);
    mData.clear();
    endRemoveRows();
    mNextID = 0;
    mDataChanged = true;
}

int History::findElementIndexByID(const int ID) const
{
    int index = -1;
    for(int i=0; i<mData.count();++i){
        if(mData[i].ID == ID){
            index = i;
            break;
        }
    }
    return index;
}

HistoryFilter::HistoryFilter(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setSourceModel(&history);
    setSortRole(History::ID);
    setFilterCaseSensitivity(Qt::CaseInsensitive);
    sort(0);
}

void HistoryFilter::setFilterDate(QString date)
{
    mDate = date;
    invalidate();
}

bool HistoryFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QString date = sourceModel()->data(index, History::DateRole).toString();
    QString tags = sourceModel()->data(index, History::TagsRole).toString();

    return (date.contains(mDate))&&(tags.contains(filterRegExp()));
}
