import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1000
    height: 800
    title: "Kurt [ " + FileIO.name() + " ]"

    background: Rectangle {
        color: "#eee"
    }

    KurtSheet {
        id: sheet

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        anchors.bottomMargin: 30
        width: 800

        textArea.text: FileIO.load()
        editStatusHandler: editStatusHandler
    }

    EditStatusHandler {
        id: editStatusHandler
        anchors.right: sheet.right
        anchors.top: sheet.top
        anchors.margins: 15
    }

}

