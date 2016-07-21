#include <QObject>
#include <QFile>

#ifndef FILEIO_H
#define FILEIO_H

class FileIO : public QObject
{
    Q_OBJECT
    QFile* pFile;
    QString mContent;
public:
    explicit FileIO(QObject *parent = 0);
    FileIO(QFile *f);
    Q_INVOKABLE bool save(QString text);
    Q_INVOKABLE bool load();
    Q_INVOKABLE QString content() { return mContent; }
    Q_INVOKABLE QString name() { return pFile != 0 ? pFile->fileName() : "Untitled"; }
    Q_INVOKABLE bool isSet() { return pFile != 0; }
    Q_INVOKABLE void setFile(QString fileName);
    ~FileIO();

signals:

public slots:
};

#endif // FILEIO_H
