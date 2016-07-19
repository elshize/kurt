#include "fileio.h"
#include <QFile>
#include <QTextStream>

FileIO::FileIO(QObject *parent) : QObject(parent)
{
}

FileIO::FileIO(QString f): file(f)
{
}

void FileIO::save(QString text) {

    file.open(QIODevice::ReadWrite | QIODevice::Truncate | QFile::Text);
    QTextStream stream(&file);
    stream << text;
    stream.flush();
    file.close();

}

QString FileIO::load() {

    file.open(QIODevice::ReadWrite | QFile::Text);
    QTextStream stream(&file);
    QString result = stream.readAll();
    file.close();
    return result;

}

QString FileIO::name() {
    return file.fileName();
}

FileIO::~FileIO()
{

}
