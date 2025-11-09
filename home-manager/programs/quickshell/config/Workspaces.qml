pragma ComponentBehavior: Bound;

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

ColumnLayout {
	id: root
	required property var bar;

	readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen);
	property bool active_monitor: Hyprland.focusedMonitor == monitor

	// destructor takes care of nulling
	signal workspaceAdded(workspace: HyprlandWorkspace);

	Layout.fillWidth: true
	// anchors.leftMargin: 20 
	// anchors.rightMargin: 20
	spacing: 5

	Repeater {
		model: 10

		Rectangle {
			id: workspaceRect
			required property int index;

			property HyprlandWorkspace workspace: null;

			property int wsIndex: index;
			property bool exists: workspace != null;
			property bool active: workspace?.active ?? false

			Connections {
				target: root

				function onWorkspaceAdded(workspace: HyprlandWorkspace) {
					if (workspace.id == 1 + workspaceRect.wsIndex) {
						workspaceRect.workspace = workspace;
					}
				}
			}

			property bool active_workspace: root.monitor.activeWorkspace.id - 1 == index


			property real animActive: active_workspace ? 1 : 0
			Behavior on animActive { NumberAnimation { duration: 100 } }

			property real animExists: exists ? 1 : 0
			Behavior on animExists { NumberAnimation { duration: 100 } }
			property real animMonitor: active_monitor ? 1 : 0
			Behavior on animMonitor { NumberAnimation { duration: 100 } }



			implicitHeight: 12
			Layout.fillWidth: true
			Layout.leftMargin:  4
			Layout.rightMargin: 4
			radius: 5


			property color activeColor: ShellGlobals.interpolateColors(animActive, ShellGlobals.colors.blue, ShellGlobals.colors.green)
			property color newColor: ShellGlobals.interpolateColors(animMonitor, activeColor.darker(2), activeColor)

			border.color: newColor
			border.width: exists ? 0 : 1
			// border.width: 0

			color: ShellGlobals.interpolateColors(animExists, "#00000000", newColor);
		}
	}

	Connections {
		target: Hyprland.workspaces

		function onObjectInsertedPost(workspace) {
			root.workspaceAdded(workspace);
		}
	}

	Component.onCompleted: {
		Hyprland.workspaces.values.forEach(workspace => {
			root.workspaceAdded(workspace)
		});
	}
}
