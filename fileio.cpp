#include "fileio.h"

#include <QFile>
#include <QTextStream>


FileIO::FileIO(QObject *parent) : QObject(parent)
{

}

FileIO::FileIO(std::unique_ptr<QFile> f) : pFile(std::move(f))
{

}

bool FileIO::save(QString text) {

    if (!pFile) return false;
    if (!pFile->open(QIODevice::ReadWrite | QIODevice::Truncate)) return false;
    QTextStream stream(pFile.get());
    stream << text;
    stream.flush();
    pFile->close();

    return true;

}

bool FileIO::load() {

    if (pFile == 0) return false;
    if (!pFile->open(QIODevice::ReadWrite | QFile::Text)) return false;
    QTextStream stream(pFile.get());
    mContent = stream.readAll();
    pFile->close();
    return true;

}

void FileIO::setFile(QString fileName) {

    pFile = std::unique_ptr<QFile>(new QFile(fileName));

}
