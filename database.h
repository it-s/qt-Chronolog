#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>
#include <QAbstractListModel>
class DataBase : public QAbstractListModel
{
    Q_OBJECT
public:
    DataBase(QString organizationName, QString applicationName, QObject *parent = 0);
    ~DataBase();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;


public slots:
    //this query will set the model view
    void setModelQuery(const QString& q);
   //refresh the model after add, insert or remove .. or change db
    void refresh();

    //run a custom query
    void execQuery(const QString& q);

    //append item
    void appendRecord( const QString& result);
    void removeRecord(int id);
    void updateRecord(int id, const QString& result);
    void clear();


private:
QSqlDatabase mDb;
QVariantList mDatas;
QString mQuery;
bool mChanged;

bool queryDB(const QString &q);

};

#endif // DATABASE_H
