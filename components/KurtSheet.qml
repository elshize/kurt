import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Flickable {
    id: flickable
    property alias textArea: textArea
    property real padding: 40
    property EditStatusHandler editStatusHandler: EditStatusHandler {}
    property bool updateStatus: false

    TextArea.flickable: TextArea {
        id: textArea

        anchors.fill: parent

        focus: true

        font.family: "Monospace"
        font.pointSize: 11

        selectByMouse: true
        selectionColor: "#ddd"

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

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            acceptedButtons: Qt.NoButton
        }

        onTextChanged: {
            editStatusHandler.edited()
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
            scrollBar.active = true
            move(flickable.height)
            scrollBar.active = false
        }

        function pageUp() {
            scrollBar.active = true
            move(-flickable.height)
            scrollBar.active = false
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

    ScrollBar.vertical: ScrollBar {
        id: scrollBar

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: scrollBar.active = true
            onExited: scrollBar.active = false
        }

        Timer {
            id: statusTimer
            interval: 500; running: false; repeat: false
            onTriggered: scrollBar.active = false
        }
    }

}
