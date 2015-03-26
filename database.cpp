#include "database.h"
#include <QDebug>
#include <QDateTime>
#include <QSettings>
#include <QFileInfo>

DataBase::DataBase(QString organizationName, QString applicationName, QObject *parent) :
    QAbstractListModel(parent)
{
    QSettings cfg(organizationName, applicationName);

    mDb = QSqlDatabase::addDatabase("QSQLITE");
    qDebug("Attempt to open database at:");
    qDebug() << QFileInfo(cfg.fileName()).absolutePath() + "/" + applicationName + ".sqlite";
    mDb.setDatabaseName(QFileInfo(cfg.fileName()).absolutePath() + "/" + applicationName + ".sqlite");

    if (mDb.open()) {
        qDebug("Database opened sucessfully");
        if ( !mDb.tables().contains( QLatin1String("history") )) {
            qDebug("history not found in database: creating table");
            QSqlQuery query;
            query.exec(QString("CREATE TABLE `history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT,`result` TEXT);"));
        }
    }else{
        qDebug("Error opening database.");
    }
}

DataBase::~DataBase()
{
    mDb.close();
}

int DataBase::rowCount(const QModelIndex &parent) const
{
    return mDatas.count();
}

QVariant DataBase::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();


    if ( role == Qt::DisplayRole)
    {
        return mDatas.at(index.row());

    }

    return QVariant();
}

void DataBase::setModelQuery(const QString &q)
{
    qDebug("Setting new query: " + q.toLatin1());
    mQuery = q;
    refresh();
}

void DataBase::refresh()
{
    qDebug("Refresh data store");
    beginRemoveRows(QModelIndex(),0,mDatas.count());
    mDatas.clear();
    endRemoveRows();

    QSqlQuery query(mQuery);

    while (query.next())
    {
        QSqlRecord record = query.record();
        QVariantMap recData;

        for ( int i=0; i<record.count(); ++i)
        {
            QString key = record.fieldName(i);
            QVariant value = record.value(i);
//            qDebug("Adding to model: key="+key.toLatin1()+"; value="+value.toString().toLatin1());
            recData.insert(key, value);
        }

        mDatas.append(recData);

    }

    if (mDatas.isEmpty())
        return;

    beginInsertRows(QModelIndex(),0,mDatas.count()-1);
    endInsertRows();
}

void DataBase::execQuery(const QString &q)
{
    queryDB(q);
}

void DataBase::appendRecord(const QString &result)
{
    qDebug("Adding new record " + result.toLatin1());
    queryDB(QString("INSERT INTO history (date,result) VALUES ('%1','%2')").arg(QString::number(QDateTime::currentDateTime().toTime_t())).arg(result));
    refresh();
}

void DataBase::removeRecord(int id)
{
    queryDB(QString("DELETE FROM history WHERE id=%1").arg(mDatas.value(id).toMap().value("id").toInt()));
    refresh();
}

void DataBase::updateRecord(int id, const QString &result)
{
}

void DataBase::clear()
{
    queryDB("DELETE from history");
    refresh();
}

bool DataBase::queryDB(const QString &q)
{
    qDebug("Running query: " + q.toLatin1());
    QSqlQuery query;
    if (query.exec(q)){
        qDebug("Query executed successfully");
        return true;
    }else{
        qDebug("Query executed failed");
        qDebug() << mDb.lastError();
    }
    return false;
}

