#include "spellcheck.h"
#include "spellchecksyntaxhighlighter.h"


SpellCheck::SpellCheck(QObject *parent) : QObject(parent)
{

}

void SpellCheck::setTextDocument(QQuickTextDocument *quickTextDocument)
{
    textDocument = quickTextDocument->textDocument();
    syntaxHighlighter = new SpellCheckSyntaxHighlighter(textDocument);
}

void SpellCheck::toggle()
{
    if (syntaxHighlighter != 0) syntaxHighlighter->toggle();
}
