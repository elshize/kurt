#include "fileio.h"
#include <QFile>
#include <QTextStream>

FileIO::FileIO(QObject *parent) : QObject(parent)
{
}

FileIO::FileIO(QFile *f)
{
    pFile = f;
}

bool FileIO::save(QString text) {

    if (pFile == 0) return false;
    if (!pFile->open(QIODevice::ReadWrite | QIODevice::Truncate | QFile::Text)) return false;
    QTextStream stream(pFile);
    stream << text;
    stream.flush();
    pFile->close();

    return true;

}

bool FileIO::load() {

    if (pFile == 0) return false;
    if (!pFile->open(QIODevice::ReadWrite | QFile::Text)) return false;
    QTextStream stream(pFile);
    mContent = stream.readAll();
    pFile->close();
    return true;

}

FileIO::~FileIO()
{

}
