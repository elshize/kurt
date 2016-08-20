#ifndef FILEIO_H
#define FILEIO_H

#include <QFile>
#include <QObject>

#include <memory>

class FileIO : public QObject
{
    Q_OBJECT

    std::unique_ptr<QFile> pFile;
    QString mContent;

public:
    explicit FileIO(QObject *parent = 0);
    FileIO(std::unique_ptr<QFile> f);
    Q_INVOKABLE bool save(QString text);
    Q_INVOKABLE bool load();
    Q_INVOKABLE QString content() const { return mContent; }
    Q_INVOKABLE QString name() const { return pFile ? pFile->fileName() : "Untitled"; }
    Q_INVOKABLE bool isSet() const { return pFile != nullptr; }
    Q_INVOKABLE void setFile(QString fileName);

signals:

public slots:
};

#endif // FILEIO_H
