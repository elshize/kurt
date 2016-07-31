#include <QObject>
#include <QSyntaxHighlighter>
#include <QTextDocument>
#include <QTextCodec>
#include <QSettings>
#include "hunspell/hunspell.hxx"

#ifndef SPELLCHECKSYNTAXHIGHLIGHTER_H
#define SPELLCHECKSYNTAXHIGHLIGHTER_H


class SpellCheckSyntaxHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT

    bool isOn;

    Hunspell * hunspell;
    QTextCodec *codec;

    QString encoding;
    QSettings settings;

    bool incorrect(QString word);

public:
    SpellCheckSyntaxHighlighter(QTextDocument *parent = 0);
    void highlightBlock(const QString &text) Q_DECL_OVERRIDE;
    void toggle();
    void toggle(bool on);
signals:

public slots:
};

#endif // SPELLCHECKSYNTAXHIGHLIGHTER_H
