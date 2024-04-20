#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qstringliteral.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"QtStarter/ui/main.qml"_qs);
    engine.load(url);

    return app.exec();
}