#include "spellchecksyntaxhighlighter.h"

#include <QStringRef>
#include <QTextStream>


SpellCheckSyntaxHighlighter::SpellCheckSyntaxHighlighter(QTextDocument *parent) : QSyntaxHighlighter(parent)
{
    if (settings.contains("spellcheck/dictionary")) {
        QString dictionaryPath = QString(settings.value("spellcheck/dictionary").toString());
        QString dictFile = dictionaryPath + ".dic";
        QString affixFile = dictionaryPath + ".aff";
        QByteArray dictFilePathBA = dictFile.toLocal8Bit();
        QByteArray affixFilePathBA = affixFile.toLocal8Bit();

        hunspell = new Hunspell(affixFilePathBA.constData(), dictFilePathBA.constData());

        encoding = "UTF-8";
        QFile _affixFile(affixFile);
        if (_affixFile.open(QIODevice::ReadOnly)) {
            QTextStream stream(&_affixFile);
            QRegExp enc_detector("^\\s*SET\\s+([A-Z0-9\\-]+)\\s*", Qt::CaseInsensitive);
            for(QString line = stream.readLine(); !line.isEmpty(); line = stream.readLine()) {
                if (enc_detector.indexIn(line) > -1) {
                    encoding = enc_detector.cap(1);
                }
            }
            _affixFile.close();
        }
        codec = QTextCodec::codecForName(this->encoding.toLatin1().constData());
    }
    else {
        hunspell = 0;
    }

    isOn = settings.value("option/spellcheck", false).toBool();

}

void
SpellCheckSyntaxHighlighter::highlightBlock(const QString &text)
{
    if (isOn) {
        QTextCharFormat myClassFormat;
        myClassFormat.setFontUnderline(true);

        QString pattern = "\\w+'?\\w+";

        QRegExp expression(pattern);
        int index = text.indexOf(expression);
        while (index >= 0) {
            int length = expression.matchedLength();
            if (incorrect(text.mid(index, length))) {
                setFormat(index, length, myClassFormat);
            }
            index = text.indexOf(expression, index + length);
        }
    }
}

bool
SpellCheckSyntaxHighlighter::incorrect(QString word) {
    return hunspell->spell(codec->fromUnicode(word).constData()) == 0;
}

void
SpellCheckSyntaxHighlighter::toggle()
{
    bool target = !isOn;
    if (target) {
        if (hunspell != 0) {
            toggle(true);
        }
        else {
            // TODO: Display error.
        }
    }
    else {
        toggle(false);
    }
}

void
SpellCheckSyntaxHighlighter::toggle(bool target)
{
    isOn = target;
    rehighlight();
    settings.setValue("option/spellcheck", isOn);
}
