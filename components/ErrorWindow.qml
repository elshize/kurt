import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Dialog {

    id: modal

    property string errorMessage: "Unknown error occurred."

    function showWithMessage(message) {
        errorMessage = message
        open()
    }

    width: 200
    height: 100

    title: "Ooops!"

    modality: Qt.ApplicationModal

    Image {
        id: icon
        sourceSize.width: 50
        sourceSize.height: 50
        source: "../icons/ic_error_outline_black_48px.svg"
    }

    Label {
        anchors.left: icon.right
        anchors.verticalCenter: icon.verticalCenter
        anchors.margins: 10
        text: modal.errorMessage
        renderType: Text.NativeRendering
    }

}
