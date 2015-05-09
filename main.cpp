#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "unit.h"
#include "history.h"
//#include "database.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Likalo.com");
    app.setOrganizationDomain("Likalo.com");
    app.setApplicationName("Chronolog");

//    DataBase database(app.organizationName(), app.applicationName());
    History history;

    QQmlApplicationEngine engine;
//    engine.rootContext()->setContextProperty("database", &database);
    engine.rootContext()->setContextProperty("history", &history);
#if (defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_WINPHONE))
    engine.rootContext()->setContextProperty("U", new Unit(qApp->screens().first()->size(), QSize(768,1280)));
#else
    engine.rootContext()->setContextProperty("U", new Unit());
#endif
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    return app.exec();
}
