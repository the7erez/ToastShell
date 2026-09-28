import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property string timeStr: ""
    property string dateStr: ""

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            let date = new Date()
            timeStr = date.toLocaleTimeString(Qt.locale(), "hh:mm A")
            dateStr = date.toLocaleDateString(Qt.locale(), "ddd, d MMM")
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.timeStr
            font.pixelSize: 11
            font.bold: true
            color: Style.textPrimary
        }

        Rectangle {
            width: 3
            height: 3
            radius: 1.5
            color: Style.textDim
        }

        Text {
            text: root.dateStr
            font.pixelSize: 10
            color: Style.textDim
        }
    }
}