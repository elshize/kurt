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

    Flickable {
        id: flickable

        property real padding: 40

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        anchors.bottomMargin: 30

        width: 800

        TextArea.flickable: TextArea {

            anchors.fill: parent

            property var updateStatus: false

            id: textArea
            focus: true

            font.family: "Monospace"
            font.pointSize: 11

            selectByMouse: true
            selectionColor: "#ddd"

            text: FileIO.load()

            wrapMode: TextArea.Wrap

            renderType: Text.NativeRendering
            textFormat: Text.PlainText

            leftPadding: flickable.padding
            rightPadding: flickable.padding

            background: Rectangle {
                color: "white"
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 1
                    horizontalOffset: 1
                    spread: 0.1
                    color: "#ddd"
                    samples: 20
                }
            }

            onTextChanged: {
                mainWindow.edited()
                updatePageCount()
            }

            onCursorPositionChanged: {
                moveToCenter()
            }

            Keys.onPressed: {
                if (event.key == Qt.Key_PageDown) pageDown()
                if (event.key == Qt.Key_PageUp) pageUp()
                moveToCenter()
            }

            function pageDown() {
                move(flickable.height)
            }

            function pageUp() {
                move(-flickable.height)
            }

            function move(y) {
                cursorPosition = positionAt(0, positionToRectangle(cursorPosition).y + y)
            }

            function findNextLine(text, offset) {
                return text.indexOf('\n', offset)
            }

            function moveToCenter() {
//                flickable.contentY = positionToRectangle(cursorPosition).y - flickable.height / 2
            }

        }

        ScrollBar.vertical: ScrollBar { }
    }

    Pane {
        anchors.right: flickable.right
        anchors.left: flickable.left
        anchors.top: flickable.top

        height: 75

        background: Rectangle {
            color: "transparent"
        }

        Rectangle {
            id: status
            anchors.right: parent.right
            width: 50
            height: 50
            radius: 20
            color: "#ddd"

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
        }

    }

    Pane {
        anchors.right: flickable.right
        anchors.bottom: flickable.bottom
        background: Rectangle {
            color: "transparent"
        }

        Rectangle {
            id: pagesCount
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 100
            height: 50
            radius: 20
            color: "#ddd"
            opacity: 0.8

            Label {
                id: pagesCountLabel
                anchors.centerIn: parent
            }

            NumberAnimation on opacity {
                id: pagesCountFadeOut
                from: 0.8
                to: 0
                duration: 300
            }

            NumberAnimation on opacity {
                id: pagesCountFadeIn
                from: 0
                to: 0.8
                duration: 300
            }

        }

    }

    Shortcut {
        sequence: StandardKey.Save
        onActivated: {
            FileIO.save(textArea.text);
            saved()
        }
    }

    Shortcut {
        sequence: StandardKey.New
        onActivated: {
            if (pagesCount.opacity == 0) {
                pagesCountFadeIn.start()
            }
            else {
                pagesCountFadeOut.start()
            }
        }
    }

    Timer {
        id: statusTimer
        interval: 500; running: false; repeat: false
        onTriggered: statusFadeOut.start()
    }

    function edited() {
        if (textArea.updateStatus) {
            statusIcon.source = "ic_mode_edit_black_48px.svg"
            showStatus()
        }
        textArea.updateStatus = true
    }

    function saved() {
        statusIcon.source = "ic_save_black_48px.svg"
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

    function updatePageCount() {
        var pages = Math.ceil(textArea.length / 1800)
        pagesCountLabel.text = "Pages: " + pages
    }

}

