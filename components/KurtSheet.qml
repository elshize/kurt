import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Flickable {
    id: flickable

    property alias textArea: textArea
    property real padding: 40
    property bool highlight: false
    property bool focusMode: false

    function switchFocusMode() {
        focusMode = !focusMode
        textArea.moveToCenter()
    }

    function switchLineHighlight() {
        highlight = !highlight
        textArea.moveLineHighlight()
    }

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
            layer.effect: StandardShadow {}

            Rectangle {
                id: lineHighlight
                color: "#f5f5f5"
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            acceptedButtons: Qt.NoButton
        }

        onCursorPositionChanged: {
            moveToCenter()
            moveLineHighlight()
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_PageDown) pageDown()
            if (event.key == Qt.Key_PageUp) pageUp()
            moveToCenter()
            moveLineHighlight()
        }

        Component.onCompleted: {
            moveToCenter()
            moveLineHighlight()
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
            if (focusMode) {
                flickable.contentY = positionToRectangle(cursorPosition).y - flickable.height / 2
            }
        }

        function moveLineHighlight() {
            // TODO: change height according to font size
            if (highlight) {
                lineHighlight.height = 18
                lineHighlight.y = positionToRectangle(cursorPosition).y - flickable.contentY
            }
            else {
                lineHighlight.height = 0
            }
        }

    }

    ScrollBar.vertical: ScrollBar {
        id: scrollBar

        onPositionChanged: textArea.moveLineHighlight()

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
