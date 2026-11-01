import QtQuick
import QtQuick.Controls
import app.ui.components

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height
    color: Constants.backgroundColor

    property bool checked: false
    property string message: qsTr("Hello QtDesignTemplate")
    signal toggleRequested()

    Button {
        id: button
        text: qsTr("Press me")
        anchors.centerIn: parent
        checkable: true
        checked: root.checked

        Connections {
            target: button
            function onClicked() {
                root.toggleRequested()
                animation.start()
            }
        }
    }

    Text {
        id: label
        text: root.message
        font: Constants.font
        anchors.top: button.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SequentialAnimation {
        id: animation
        ColorAnimation {
            target: root
            property: "color"
            from: Constants.backgroundColor
            to: "#2294c6"
            duration: 250
        }
        ColorAnimation {
            target: root
            property: "color"
            from: "#2294c6"
            to: Constants.backgroundColor
            duration: 250
        }
    }
}
