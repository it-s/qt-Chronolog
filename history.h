#ifndef HISTORY_H
#define HISTORY_H

#include <QObject>
#include <QAbstractListModel>
#include <QSortFilterProxyModel>
#include <QString>
#include <QList>
#include <QVariant>
#include <QHash>
#include <QByteArray>

struct HistoryItem {
    int ID;
    QString result, date,tags;
    operator QVariantMap() const
    {
        QVariantMap m;
        m["ID"]=this->ID;
        m["date"]=this->date;
        m["result"]= this->result;
        m["tags"]=this->tags;
        return m;
    }
    HistoryItem& operator=(const QVariantMap& v)
    {
        if (v.contains("ID")) this->ID = v.value("ID").toInt();
        if (v.contains("result")) this->result = v.value("result").toString();
        if (v.contains("date")) this->date = v.value("date").toString();
        if (v.contains("tags")) this->tags = v.value("tags").toString();
        return *this;
    }
};

class History : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        ID = Qt::UserRole + 1,
        DateRole,
        ResultRole,
        TagsRole
    };

    explicit History(QObject *parent = 0);
    ~History(){ if (mDataChanged) synch(); }

    void synch();

protected:
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const {return mDataRoles;}

public slots:
    QVariantMap get(const int ID);
    void set(const int ID, const QVariantMap& v);
    void add(const QVariantMap& v);
    void remove(const int ID);
    void clear();

private:
    bool mDataChanged;
    QList<HistoryItem> mData;
    QHash<int, QByteArray> mDataRoles;
    int mNextID;

    int findElementIndexByID(const int ID) const;
};



class HistoryFilter : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    HistoryFilter(QObject *parent = 0);

public slots:
    void setFilterDate(){setFilterDate("");}
    void setFilterDate(QString date);
    QString filterDate(){ return mDate; }

    QVariantMap get(const int ID){ return history.get(ID); }
    void set(const int ID, const QVariantMap& v){ history.set(ID, v); }
    void add(const QVariantMap& v){ history.add(v); }
    void remove(const int ID){ history.remove(ID); }
    void clear(){ history.clear(); }

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

private:
    QString mDate;
    History history;

};

#endif // HISTORY_H
