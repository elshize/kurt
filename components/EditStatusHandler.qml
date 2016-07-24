import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: status

    property TextArea textArea
    property bool editing: false
    property bool persisting: false

    width: 50
    height: 50

    color: "#fff"

    layer.enabled: true
    layer.effect: StandardShadow {}

    Image {
        id: statusIcon
        anchors.centerIn: parent;
    }

    NumberAnimation on opacity {
        id: statusFadeOut
        from: 0.8
        to: 0
        duration: 300
    }

    NumberAnimation on opacity {
        id: statusFadeIn
        from: 0
        to: 0.8
        duration: 300
    }

    Timer {
        id: statusTimer
        interval: 500; running: false; repeat: false
        onTriggered: statusFadeOut.start()
    }

    Connections {
        target: textArea
        onTextChanged: {
            if (!textArea.persisting) edited()
            persisting = false
        }
    }

    function setTextPersistEditing(t) {
        persisting = true
        textArea.text = t
    }

    function edited() {
        editing = true
        statusIcon.source = "../icons/ic_mode_edit_black_48px.svg"
        showStatus()
    }

    function saved() {
        editing = false
        statusIcon.source = "../icons/ic_save_black_48px.svg"
        showDisappearingStatus()
    }

    function showStatus() {
        statusTimer.stop()
        if (status.opacity == 0) {
            statusFadeIn.start()
        }
    }

    function showDisappearingStatus() {
        showStatus()
        statusTimer.start()
    }

}

