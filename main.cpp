#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include "fileio.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setApplicationName("Kurt");
    QCoreApplication::setApplicationVersion("0.1.0");
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    QCommandLineParser parser;
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("file", QCoreApplication::translate("main", "Text file to edit."));

    parser.process(app);
    const QStringList args = parser.positionalArguments();

    QFile *file;
    if (args.length() > 0) file = new QFile(args.at(0));
    else file = 0;

    engine.rootContext()->setContextProperty("FileIO", new FileIO(file));

    return app.exec();
}
