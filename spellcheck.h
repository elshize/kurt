#ifndef SPELLCHECK_H
#define SPELLCHECK_H

#include "spellchecksyntaxhighlighter.h"

#include <QObject>
#include <QQuickTextDocument>
#include <QSyntaxHighlighter>
#include <QTextDocument>


class SpellCheck : public QObject
{
    Q_OBJECT
    QTextDocument *textDocument;
    SpellCheckSyntaxHighlighter *syntaxHighlighter;
public:
    explicit SpellCheck(QObject *parent = 0);
    Q_INVOKABLE void setTextDocument(QQuickTextDocument *textDocument);
    Q_INVOKABLE void toggle();
signals:

public slots:
};

#endif // SPELLCHECK_H
