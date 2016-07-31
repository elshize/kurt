#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QTextDocument>
#include <QQmlComponent>
#include <QProcessEnvironment>
#include <QSettings>
#include "fileio.h"
#include "spellcheck.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Kurt");
    QCoreApplication::setApplicationName("Kurt");
    QCoreApplication::setApplicationVersion("0.1.0");
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCommandLineParser parser;
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("file", QCoreApplication::translate("main", "Text file to edit."));
    parser.process(app);
    const QStringList args = parser.positionalArguments();

    QFile *file;
    if (args.length() > 0) file = new QFile(args.at(0));
    else file = 0;

    engine.rootContext()->setContextProperty("SpellCheck", new SpellCheck());
    engine.rootContext()->setContextProperty("FileIO", new FileIO(file));
    engine.rootContext()->setContextProperty("Settings", new QSettings());
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

//    QSettings settings;
//    settings.setValue("spellcheck/dictionary", "/usr/share/hunspell/en_US");
//    settings.sync();

    return app.exec();
}
