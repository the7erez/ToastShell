import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property int activeWorkspace: 1
    implicitWidth: wsLayout.implicitWidth
    implicitHeight: wsLayout.implicitHeight

    Rectangle {
        id: activeIndicator
        height: 22
        radius: 11
        color: Style.accent
        y: (parent.height - height) / 2

        Behavior on x { NumberAnimation { duration: Style.animNormal; easing.type: Style.springEasing } }
        Behavior on width { NumberAnimation { duration: Style.animFast } }
    }

    RowLayout {
        id: wsLayout
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: 5
            Item {
                id: wsItem
                implicitWidth: 28
                implicitHeight: 22
                property int wsIndex: index + 1
                property bool isActive: root.activeWorkspace === wsIndex

                onIsActiveChanged: {
                    if (isActive) {
                        activeIndicator.x = wsItem.x
                        activeIndicator.width = wsItem.width
                    }
                }

                Component.onCompleted: {
                    if (isActive) {
                        activeIndicator.x = wsItem.x
                        activeIndicator.width = wsItem.width
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: parent.wsIndex
                    font.pixelSize: 11
                    font.bold: true
                    color: parent.isActive ? Style.bgDark : Style.textDim
                }
            }
        }
    }
}