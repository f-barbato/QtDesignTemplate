import QtQuick
import app.ui.components
import app.ui.pages

Window {
    id: root
    visible: true
    width: Constants.width
    height: Constants.height
    title: "QtDesignTemplate"

    // Design Studio uses the mock; main.cpp injects the C++ ViewModel.
    property var viewModel: QtObject {
        property bool checked: false
        readonly property string message: checked ? qsTr("Button Checked")
                                                 : qsTr("Hello QtDesignTemplate")
        function toggle() {
            checked = !checked
        }
    }

    Home {
        objectName: "home"
        anchors.fill: parent
        checked: root.viewModel.checked
        message: root.viewModel.message
        onToggleRequested: root.viewModel.toggle()
    }
}
