pragma Singleton

import Quickshell
import QtQuick

import Quickshell.Services.UPower 

Singleton {
  id: root
  readonly property string percentage: {
    UPower.displayDevice.isLaptopBattery ?
		qsTr("%1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
  }
}
