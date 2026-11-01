pragma Singleton
import QtQuick

QtObject {
    readonly property int width: 1920
    readonly property int height: 1080
    readonly property color backgroundColor: "#EAEAEA"
    readonly property font font: Qt.font({
        family: "Sans Serif",
        pixelSize: 16
    })
    readonly property font largeFont: Qt.font({
        family: font.family,
        pixelSize: font.pixelSize * 1.6
    })
}
