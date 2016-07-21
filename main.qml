import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
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

        textArea.text: setTextPersistEditing(loadText())
    }

    EditStatusHandler {
        id: editStatusHandler
        anchors.right: sheet.right
        anchors.top: sheet.top
        anchors.margins: 15
    }

    Shortcut {
        sequence: StandardKey.Save
        onActivated: saveOrSaveAs()
    }

    ErrorWindow {
        id: errorWindow
    }

    CloseDialog {
        id: closeDialog
        onAccepted: saveOrSaveAs(true)
        onDiscard: Qt.quit()
    }

    FileDialog {
        id: saveDialog
        property bool quit: false
        folder: shortcuts.home
        selectMultiple: false
        onAccepted: {
            FileIO.setFile(saveDialog.fileUrl.toString().replace("file://", ""))
            if (save() && quit) Qt.quit()
        }
        onRejected: quit = false
    }

    function saveOrSaveAs(quit) {
        if (!FileIO.isSet()) {
            if (quit) saveDialog.quit = true
            saveDialog.open()
            return
        }
        if (save() && quit) Qt.quit()
    }

    function save() {
        if (!FileIO.save(sheet.textArea.text)) {
            errorWindow.showWithMessage("Saving file " + FileIO.name() + " failed.")
            return false
        }
        editStatusHandler.saved()
        return true
    }

    function loadText() {
        var text = "";
        if (!FileIO.isSet()) {}
        else if (!FileIO.load()) errorWindow.showWithMessage("Loading file " + FileIO.name() + " failed.");
        else text = FileIO.content();
        return text;
    }

}

