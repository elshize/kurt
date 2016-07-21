import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import "components"

Window {
    id: mainWindow
    visible: true
    width: 1000
    height: 800

    color: "#eee"

    onClosing: {
        if (editStatusHandler.editing) {
            closeDialog.open()
            close.accepted = false
        }
    }

    KurtSheet {
        id: sheet

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        anchors.bottomMargin: 30
        width: 800

        editStatusHandler: editStatusHandler

        textArea.text: loadText()
    }

    EditStatusHandler {
        id: editStatusHandler
        anchors.right: sheet.right
        anchors.top: sheet.top
        anchors.margins: 15
    }

    Shortcut {
        sequence: StandardKey.Save
        onActivated: save()
    }

    ErrorWindow {
        id: errorWindow
    }

    CloseDialog {
        id: closeDialog
        onAccepted: {
            save()
            Qt.quit()
        }
        onDiscard: Qt.quit()
    }

    function save() {
        if (!FileIO.save(sheet.textArea.text)) errorWindow.showWithMessage("Saving file " + FileIO.name() + " failed.")
        else editStatusHandler.saved()
    }

    function loadText() {
        if (!FileIO.isSet()) { return "" }
        else if (!FileIO.load()) errorWindow.showWithMessage("Loading file " + FileIO.name() + " failed.");
        else return FileIO.content();
    }

}

