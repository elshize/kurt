import QtQuick 2.7

Item {

    anchors.fill: parent

    property list<Item> items
    property KurtSheet sheet
    property bool isTyping: false

    Connections {
        target: sheet.textArea
        onTextChanged: {
            idle.stop()
            if (!isTyping) typing.start()
            idle.start()
        }
    }

    Timer {
        id: idle
        interval: 2000; running: false; repeat: false
        onTriggered: fadeIn()
    }

    Timer {
        id: typing
        interval: 3000; running: false; repeat: false
        onTriggered: fadeOut()
    }

    function fadeOut() {
        isTyping = true
        idle.stop()
        idle.start()
        for (var i = 0; i < items.length; i++) {
            items[i].hide()
        }
    }

    function fadeIn() {
        typing.stop()
        isTyping = false
        for (var i = 0; i < items.length; i++) {
            items[i].show()
        }
    }

    function forceFadeIn() {
        isTyping = false
        idle.stop()
        typing.stop()
        for (var i = 0; i < items.length; i++) {
            items[i].show()
        }
    }

}
