QT += qml quick widgets

CONFIG += c++11

SOURCES += main.cpp \
    fileio.cpp \
    spellcheck.cpp \
    spellchecksyntaxhighlighter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    fileio.h \
    spellcheck.h \
    spellchecksyntaxhighlighter.h

unix {
    LIBS += -L/usr/lib -L/usr/lib/x86_64-linux-gnu -lhunspell
}
