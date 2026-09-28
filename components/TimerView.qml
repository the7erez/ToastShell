import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"

ColumnLayout {
    id: timerRoot
    spacing: 10

    signal closeRequested()
    property int timerSeconds: 0
    property int initialSeconds: 0
    property bool timerRunning: false

    function formatTime(secs) {
        let m = Math.floor(secs / 60)
        let s = secs % 60
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
    }

    // Header
    RowLayout {
        Layout.fillWidth: true
        Text {
            text: "⏱️ Timer"
            font.bold: true
            font.pixelSize: 12
            color: Style.textPrimary
        }
        Item { Layout.fillWidth: true }
        Text {
            text: "✕"
            font.pixelSize: 11
            color: Style.textDim
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: timerRoot.closeRequested()
            }
        }
    }

    // Modern Circular Display Box
    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        width: 140
        height: 60
        radius: 16
        color: Qt.rgba(0, 0, 0, 0.35)
        border.color: timerRunning ? Style.accent : Qt.rgba(1, 1, 1, 0.1)
        border.width: 1

        Behavior on border.color { ColorAnimation { duration: 300 } }

        // Glow Line in bottom when running
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: 2
            width: timerRunning ? parent.width * 0.7 : 0
            radius: 1
            color: Style.accent

            Behavior on width { NumberAnimation { duration: Style.animNormal; easing.type: Style.smoothEasing } }
        }

        Text {
            anchors.centerIn: parent
            text: timerRoot.formatTime(timerRoot.timerSeconds)
            font.pixelSize: 28
            font.bold: true
            color: timerRoot.timerSeconds > 0 ? Style.accent : Style.textPrimary

            // Scaling subtle pulse on tick
            scale: timerRunning && (timerRoot.timerSeconds % 2 === 0) ? 1.03 : 1.0
            Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
        }
    }

    // Interactive Control Chips
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 6

        // Preset +1m
        Rectangle {
            width: 42; height: 28; radius: 14
            color: Qt.rgba(1, 1, 1, 0.08)
            Text { anchors.centerIn: parent; text: "+1m"; font.pixelSize: 10; color: Style.textPrimary; font.bold: true }
            MouseArea { 
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    timerRoot.timerSeconds += 60
                    if (timerRoot.initialSeconds === 0) timerRoot.initialSeconds = timerRoot.timerSeconds
                }
            }
        }

        // Preset +5m
        Rectangle {
            width: 42; height: 28; radius: 14
            color: Qt.rgba(1, 1, 1, 0.08)
            Text { anchors.centerIn: parent; text: "+5m"; font.pixelSize: 10; color: Style.textPrimary; font.bold: true }
            MouseArea { 
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    timerRoot.timerSeconds += 300
                    if (timerRoot.initialSeconds === 0) timerRoot.initialSeconds = timerRoot.timerSeconds
                }
            }
        }

        // Start / Pause Main Action Button
        Rectangle {
            width: 52; height: 28; radius: 14
            color: timerRoot.timerRunning ? Qt.rgba(1, 0.2, 0.2, 0.25) : Style.accent
            border.color: timerRoot.timerRunning ? "#ff5555" : "transparent"

            Text { 
                anchors.centerIn: parent
                text: timerRoot.timerRunning ? "Pause" : "Start"
                font.pixelSize: 10
                font.bold: true
                color: timerRoot.timerRunning ? "#ff5555" : "#000000"
            }

            MouseArea { 
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: timerRoot.timerRunning = !timerRoot.timerRunning 
            }
        }

        // Reset Button
        Rectangle {
            width: 28; height: 28; radius: 14
            color: Qt.rgba(1, 1, 1, 0.08)
            Text { anchors.centerIn: parent; text: "↺"; font.pixelSize: 11; color: Style.textPrimary }
            MouseArea { 
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    timerRoot.timerRunning = false
                    timerRoot.timerSeconds = 0
                    timerRoot.initialSeconds = 0
                }
            }
        }
    }
}