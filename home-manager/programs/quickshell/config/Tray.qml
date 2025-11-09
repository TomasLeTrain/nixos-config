pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

ColumnLayout {
	Layout.fillWidth: true

	Repeater {
		model: SystemTray.items
		WrapperMouseArea {
			id: mouse_area
			required property SystemTrayItem modelData
			property alias item: mouse_area.modelData

			Layout.fillWidth: true

			acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
			hoverEnabled: true

			onClicked: mouse => {
				if (mouse.button == Qt.LeftButton) {
					item.activate();
				} else if (mouse.button == Qt.MiddleButton) {
					item.secondaryActivate();
				} else if (mouse.button == Qt.RightButton) {
					menuAnchor.open();
				}
			}
			onWheel: event => {
				event.accepted = true;
				const points = event.angleDelta.y / 120;
				modelData.scroll(points, false);
			}

			IconImage {
				id: image
				// TODO: fix this?
				source: mouse_area.item.title != "dropbox" ? mouse_area.item.icon : "file:/home/tomas/.dropbox-dist/dropbox-lnx.x86_64-233.4.4938/images/hicolor/16x16/status/dropboxstatus-idle.png"
				visible: source != ""
				implicitSize: 22
			}

			QsMenuAnchor {
				id: menuAnchor
				menu: mouse_area.item.menu

				anchor.window: mouse_area.QsWindow.window
				anchor.adjustment: PopupAdjustment.Flip

				anchor.onAnchoring: {
					const window = mouse_area.QsWindow.window;
					const widgetRect = window.contentItem.mapFromItem(mouse_area, -22, -4, mouse_area.width, mouse_area.height);
					menuAnchor.anchor.rect = widgetRect;
				}
			}
		}
	}
}
