import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Dialog {

    property Window window
    property KurtSheet sheet
    property string oldText

    id: dialog

    width: 200
    height: 100

    title: "Save the file?"

    modality: Qt.ApplicationModal
    standardButtons: StandardButton.Save | StandardButton.Discard | StandardButton.Cancel

    Image {
        id: icon
        sourceSize.width: 50
        sourceSize.height: 50
        source: "../icons/ic_info_outline_black_48px.svg"
    }

    Label {
        anchors.left: icon.right
        anchors.verticalCenter: icon.verticalCenter
        anchors.margins: 10
        text: "Do you want to save your unsaved changes before you exit?"
        renderType: Text.NativeRendering
    }

    Connections {
        target: window
        onClosing: {
            if (sheet.textArea.text != oldText) {
                closeDialog.open()
                close.accepted = false
            }
        }
    }

}
