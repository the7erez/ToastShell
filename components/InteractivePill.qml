import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme"

Item {
    id: root

    // Dimensions dynamically follow the main morphing body
    implicitWidth: mainBg.width
    implicitHeight: mainBg.height

    property int activeWorkspace: 1
    property int currentPage: 0 // 0: Workspaces, 1: Clock
    property bool isExpanded: false 
    property int panelPage: 0 // 0: Calendar, 1: Timer

    // Timer logic sync
    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: timerView.timerRunning
        onTriggered: {
            if (timerView.timerSeconds > 0) timerView.timerSeconds--
            else timerView.timerRunning = false
        }
    }

    // 🌟 Master Dynamic Island Shape (Morphing Container)
    Rectangle {
        id: mainBg

        // Smart dynamic target dimensions
        readonly property real targetWidth: {
            if (root.isExpanded) return 260
            if (timerView.timerSeconds > 0 && root.currentPage === 1) return 220 // Expands to absorb Timer Dot internally
            return root.currentPage === 0 ? 180 : 150
        }

        readonly property real targetHeight: root.isExpanded ? 210 : 34
        readonly property real targetRadius: root.isExpanded ? 20 : 17

        width: targetWidth
        height: targetHeight
        radius: targetRadius

        color: Style.bgCard
        border.color: (timerView.timerRunning && !root.isExpanded) ? Style.accent : Qt.rgba(1, 1, 1, 0.12)
        border.width: 1

        // Smooth Fluid Animations (Morph Effect)
        Behavior on width {
            SpringAnimation { spring: 3.5; damping: 0.28; epsilon: 0.25 }
        }
        Behavior on height {
            SpringAnimation { spring: 3.5; damping: 0.28; epsilon: 0.25 }
        }
        Behavior on radius {
            NumberAnimation { duration: 200 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }

        // Gesture interactions
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                if (mouse.button === Qt.RightButton && root.currentPage === 1) {
                    root.isExpanded = !root.isExpanded
                }
            }

            property real startX: 0
            onPressed: mouse => startX = mouse.x
            onReleased: mouse => {
                let diff = mouse.x - startX
                if (!root.isExpanded) {
                    if (diff < -20 && root.currentPage < 1) root.currentPage++
                    else if (diff > 20 && root.currentPage > 0) root.currentPage--
                } else {
                    if (diff < -25 && root.panelPage < 1) root.panelPage++
                    else if (diff > 25 && root.panelPage > 0) root.panelPage--
                }
            }
        }

        // Masking rounded corners during expansion
        Rectangle {
            id: contentMask
            anchors.fill: parent
            radius: mainBg.radius
            visible: false
        }

        Item {
            anchors.fill: parent
            layer.enabled: true
            layer.effect: OpacityMask { maskSource: contentMask }

            // ---------------- COMPACT MODE ----------------
            Item {
                anchors.fill: parent
                opacity: root.isExpanded ? 0.0 : 1.0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: 150 } }

                // Workspaces Page
                Item {
                    width: parent.width; height: parent.height
                    x: root.currentPage === 0 ? 0 : -180
                    opacity: root.currentPage === 0 ? 1.0 : 0.0
                    Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    WorkspacesBar {
                        anchors.centerIn: parent
                        activeWorkspace: root.activeWorkspace
                    }
                }

                // Clock Page + Embedded Morphing Timer Indicator
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8
                    x: root.currentPage === 1 ? 0 : 150
                    opacity: root.currentPage === 1 ? 1.0 : 0.0

                    Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    ClockWidget {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    // Integrated Timer Badge (Morphs directly from/to expanded state)
                    RowLayout {
                        id: integratedTimerBadge
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 5
                        visible: timerView.timerSeconds > 0
                        opacity: visible ? 1.0 : 0.0

                        Behavior on opacity { NumberAnimation { duration: 200 } }

                        // Pulsing Live Indicator
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: Style.accent

                            SequentialAnimation on opacity {
                                running: timerView.timerRunning && !root.isExpanded
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.2; duration: 500 }
                                NumberAnimation { to: 1.0; duration: 500 }
                            }
                        }

                        Text {
                            text: timerView.formatTime(timerView.timerSeconds)
                            font.pixelSize: 10
                            font.bold: true
                            color: Style.accent
                        }
                    }
                }
            }

            // ---------------- EXPANDED MODE ----------------
            Item {
                anchors.fill: parent
                anchors.margins: 12
                opacity: root.isExpanded ? 1.0 : 0.0
                visible: opacity > 0.01

                Behavior on opacity { NumberAnimation { duration: 200 } }

                CalendarView {
                    anchors.fill: parent
                    x: root.panelPage === 0 ? 0 : -220
                    opacity: root.panelPage === 0 ? 1.0 : 0.0
                    onCloseRequested: root.isExpanded = false

                    Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                TimerView {
                    id: timerView
                    anchors.fill: parent
                    x: root.panelPage === 1 ? 0 : 220
                    opacity: root.panelPage === 1 ? 1.0 : 0.0
                    onCloseRequested: root.isExpanded = false

                    Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
        }
    }
}