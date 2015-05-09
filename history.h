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
    int id;
    QString result, date,tags;
    operator QVariantMap() const
    {
        QVariantMap m;
        m["id"]=this->id;
        m["date"]=this->date;
        m["result"]= this->result;
        m["tags"]=this->tags;
        return m;
    }
    HistoryItem& operator=(const QVariantMap& v)
    {
        if (v.contains("id")) this->id = v.value("id").toInt();
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
    QVariantMap get(const int id);
    void set(const int id, const QVariantMap& v);
    void add(const QVariantMap& v);
    void remove(const int id);
    void clear();

private:
    bool mDataChanged;
    QList<HistoryItem> mData;
    QHash<int, QByteArray> mDataRoles;
    int mNextID;

    int findElementIndexById(const int id) const;
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

    QVariantMap get(const int id){ return history.get(id); }
    void set(const int id, const QVariantMap& v){ history.set(id, v); }
    void add(const QVariantMap& v){ history.add(v); }
    void remove(const int id){ history.remove(id); }
    void clear(){ history.clear(); }

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

private:
    QString mDate;
    History history;

};

#endif // HISTORY_H
