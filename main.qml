import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import "components"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1000
    height: 800

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

        textArea.text: editStatusHandler.setTextPersistEditing(loadText())
    }

    EditStatusHandler {
        id: editStatusHandler
        anchors.left: sheet.right
        anchors.leftMargin: 10
        anchors.top: sheet.top
        textArea: sheet.textArea
    }

    ColumnLayout {

        id: rightBottomPanel

        anchors.bottom: sheet.bottom
        anchors.left: sheet.right
        anchors.leftMargin: 10
        spacing: 0

        NumberAnimation on opacity {
            id: rightBottomPanelFadeIn
            from: 0
            to: 1
            duration: 500
        }

        NumberAnimation on opacity {
            id: rightBottomPanelFadeOut
            from: 1
            to: 0
            duration: 500
        }

        PageCount {
            id: pageCount
            sheet: sheet
        }

        function show() {
            if (opacity == 0) rightBottomPanelFadeIn.start()
        }

        function hide() {
            if (opacity != 0) rightBottomPanelFadeOut.start()
        }

    }

    Fader {
        sheet: sheet
        items: [
            rightBottomPanel
        ]
    }

    /***** Global shortcuts *****/

    Shortcut {
        sequence: StandardKey.Save
        onActivated: saveOrSaveAs()
    }

    Shortcut {
        sequence: "F2"
        onActivated: pageCount.visible = !pageCount.visible
    }

    Shortcut {
        sequence: "F3"
        onActivated: sheet.switchLineHighlight()
    }

    Shortcut {
        sequence: "F4"
        onActivated: sheet.switchFocusMode()
    }


    /***** Dialogs *****/

    ErrorWindow {
        id: errorWindow
    }

    CloseDialog {
        id: closeDialog
        onAccepted: saveOrSaveAs(true)
        onDiscard: Qt.quit()
        window: mainWindow
        sheet: sheet
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


    /***** Functions *****/

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
            return false
        }
        editStatusHandler.saved()
        closeDialog.oldText = sheet.textArea.text
        return true
    }

    function loadText() {
        var text = "";
        if (!FileIO.isSet()) {}
        else if (!FileIO.load()) errorWindow.showWithMessage("Loading file " + FileIO.name() + " failed.");
        else text = FileIO.content();
        closeDialog.oldText = text
        return text;
    }

}

