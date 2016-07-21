import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: status

    property TextArea textArea
    property bool editing: false

    width: 50
    height: 50

    color: "#eee"

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

    function edited() {
        if (sheet.updateStatus) {
            statusIcon.source = "../icons/ic_mode_edit_black_48px.svg"
            showStatus()
            editing = true
        }
        sheet.updateStatus = true
    }

    function saved() {
        statusIcon.source = "../icons/ic_save_black_48px.svg"
        showDisappearingStatus()
        sheet.updateStatus = false
        editing = false
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

