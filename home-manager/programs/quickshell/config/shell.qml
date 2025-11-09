//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts

ShellRoot {
	id: root
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

			implicitWidth: 60

			color: "transparent"
			WlrLayershell.namespace: "shell:bar"

			Rectangle {
				anchors.fill: parent
				anchors.margins: 7

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

					Text {
						Layout.alignment: Qt.AlignHCenter
						color: ShellGlobals.colors.fg
						font.pointSize: 10
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
