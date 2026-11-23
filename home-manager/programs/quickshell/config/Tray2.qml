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
        Column {
            id: item_root

            required property SystemTrayItem modelData
            property alias item: item_root.modelData

            LazyLoader {
                id: popupLoader

                // start loading immediately
                loading: true

                // this window will be loaded in the background during spare
                // frame time unless active is set to true, where it will be
                // loaded in the foreground
                PopupWindow {
                    id: popup
                    anchor.window: mouse_area.QsWindow.window
                    anchor.adjustment: PopupAdjustment.Flip
                    grabFocus: true

                    anchor.onAnchoring: {
                        const window = mouse_area.QsWindow.window;
                        const widgetRect = window.contentItem.mapFromItem(mouse_area, -22, -4, mouse_area.width, mouse_area.height);
                        popup.anchor.rect = widgetRect;
                    }

                    // color: "black"
                    // // some heavy component here
                    // Text {
                    //     color: "white"
                    //     text: "what"
                    // }
                    TrayItem {
                        trayItem: item_root.item.menu
                    }

                    width: 200
                    height: 200
                }
            }

            WrapperMouseArea {
                id: mouse_area
                property alias item: item_root.modelData

                Layout.fillWidth: true

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true

                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton) {
                        // item.activate();
                        popupLoader.item.visible = !popupLoader.item.visible;
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
                    source: mouse_area.item.title != "dropbox" ? mouse_area.item.icon : "file:/home/tomas/.dropbox-dist/dropbox-lnx.x86_64-236.4.5918/images/hicolor/16x16/status/dropboxstatus-idle.png"
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
}
