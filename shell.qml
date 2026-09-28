import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./components"
import "./theme"

PanelWindow {
    id: window

    anchors {
        top: true
        left: true
        right: true
    }

    // ارتفاع ثابت وكافي لمنع إعادة حساب أبعاد الـ Window مع Hyprland
    implicitHeight: 250
    color: "transparent"

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top
    // تثبيت المساحة المحجوزة للبرامج
    WlrLayershell.exclusiveZone: 46

    // حصر التفاعل بداخل أبعاد الـ Pill الحالية فقط
    mask: Region {
        item: pill
    }

    Process {
        id: hyprProcess
        command: ["python3", Qt.resolvedUrl("services/workspaces.py").toString().replace("file://", "")]
        running: true

        stdout: SplitParser {
            onRead: data => {
                try {
                    let parsed = JSON.parse(data);
                    if (parsed.event === "workspace") {
                        pill.activeWorkspace = parseInt(parsed.active);
                    }
                } catch (e) {}
            }
        }
    }

    Item {
        anchors.fill: parent

        InteractivePill {
            id: pill
            anchors.horizontalCenter: parent.horizontalCenter
            y: 6
        }
    }
}