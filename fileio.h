#include <QObject>
#include <QFile>

#ifndef FILEIO_H
#define FILEIO_H


class FileIO : public QObject
{
    Q_OBJECT
    QFile file;
public:
    explicit FileIO(QObject *parent = 0);
    FileIO(QString f);
    Q_INVOKABLE void save(QString text);
    Q_INVOKABLE QString load();
    Q_INVOKABLE QString name();
    ~FileIO();

signals:

public slots:
};

#endif // FILEIO_H
