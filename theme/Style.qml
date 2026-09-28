import QtQuick

pragma Singleton

QtObject {
    readonly property color bgDark: "#090a0f"
    readonly property color bgCard: "#0f1117"
    readonly property color accent: "#38bdf8"
    readonly property color textPrimary: "#f8fafc"
    readonly property color textDim: "#64748b"

    readonly property int animFast: 180
    readonly property int animNormal: 320

    readonly property var springEasing: Easing.OutBack
    readonly property var smoothEasing: Easing.OutCubic
}