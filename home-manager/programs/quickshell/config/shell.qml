//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Shapes

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: silly
            required property var modelData
            screen: modelData
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "shell:silly"
            exclusionMode: ExclusionMode.Ignore
            // exclusionZone: ExclusionZone.

            color: "transparent"

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

            // TODO: make an actually good solution to the problem
            Rectangle {
                anchors.fill: parent
                // anchors.margins: 0
                anchors.rightMargin: 54
                radius: 0
                border.width: 11
                color: "transparent"
                border.color: ShellGlobals.colors.surrround_color
                Rectangle {
                    anchors.fill: parent
                    // anchors.rightMargin: 45
                    color: "transparent"
                    border.color: ShellGlobals.colors.surrround_color
                    radius: 25
                    border.width: 11
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel_window
            required property var modelData
            screen: modelData

            anchors {
                top: true
                right: true
                bottom: true
            }

            implicitWidth: 55

            // color: "transparent"
            color: ShellGlobals.colors.bar
            WlrLayershell.namespace: "shell:bar"

            Rectangle {
                anchors.fill: parent
                // anchors.margins: 0
                anchors.rightMargin: 7
                // anchors.leftMargin: 10

                radius: 5
                border.width: 1

                color: ShellGlobals.colors.bar
                border.color: ShellGlobals.colors.barOutline

                ColumnLayout {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }
                    anchors.topMargin: 10

                    Workspaces {
                        bar: panel_window
                    }
                }

                ColumnLayout {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    anchors.bottomMargin: 10
                    spacing: 7

                    Tray {}
                    // Tray2 {}
										// Wifi {}

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        color: ShellGlobals.colors.fg
                        font.pointSize: 11
                        text: Battery.percentage
                    }

                    ColumnLayout {
                        spacing: 0
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Text {
                            color: ShellGlobals.colors.fg
                            font.pointSize: 20
                            text: Time.hour
                        }
                        Text {
                            color: ShellGlobals.colors.fg
                            font.pointSize: 20
                            text: Time.minute
                        }
                    }
                }
            }
        }
    }
}
