import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {

    property KurtSheet sheet: KurtSheet {}

    width: 50
    height: 70
    color: "white"

    layer.enabled: true
    layer.effect: StandardShadow {}

    ColumnLayout {

        anchors.centerIn: parent
        anchors.margins: 0

        Image {
            source: "../icons/ic_library_books_black_48px.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.7
        }

        NativeLabel {
            id: pagesNumber
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Monospace"
            text: "0"
        }
    }

    Connections {
        target: sheet.textArea
        onTextChanged: {
            pagesNumber.text = countPages()
        }
    }

    function countPages() {
        return Math.ceil(sheet.textArea.length / 1800)
    }

}
