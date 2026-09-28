import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../theme"

ColumnLayout {
    id: calendarRoot
    spacing: 4

    signal closeRequested()
    property int selectedDay: new Date().getDate()

    // Header
    RowLayout {
        Layout.fillWidth: true
        Text {
            text: Qt.formatDate(new Date(), "MMMM yyyy")
            font.bold: true
            font.pixelSize: 11
            color: Style.textPrimary
        }
        Item { Layout.fillWidth: true }
        Text {
            text: "✕"
            font.pixelSize: 10
            color: Style.textDim
            MouseArea {
                anchors.fill: parent
                onClicked: calendarRoot.closeRequested()
            }
        }
    }

    // Days Header
    DayOfWeekRow {
        Layout.fillWidth: true
        delegate: Text {
            text: model.shortName.charAt(0)
            font.pixelSize: 8
            font.bold: true
            color: Style.textDim
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Month Grid
    MonthGrid {
        id: grid
        Layout.fillWidth: true
        Layout.fillHeight: true
        delegate: Rectangle {
            property bool isCurrentMonth: model.month === grid.month
            property bool isTodayDate: Boolean(model.isToday)
            property bool isSelected: calendarRoot.selectedDay === model.day && isCurrentMonth

            implicitWidth: 18
            implicitHeight: 18
            radius: 9
            color: isSelected ? Style.accent : (isTodayDate ? Qt.rgba(1,1,1,0.1) : "transparent")

            Text {
                anchors.centerIn: parent
                text: model.day
                font.pixelSize: 9
                font.bold: isTodayDate || isSelected
                color: isSelected ? "#000000" : (isCurrentMonth ? Style.textPrimary : Qt.rgba(1,1,1,0.2))
            }

            MouseArea {
                anchors.fill: parent
                enabled: isCurrentMonth
                onClicked: calendarRoot.selectedDay = model.day
            }
        }
    }
}