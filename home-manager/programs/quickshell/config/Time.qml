pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "ddd MMM d hh:mm AP yyyy")
  }
  readonly property string hour: {
    Qt.formatDateTime(clock.date, "hh")
  }
  readonly property string minute: {
    Qt.formatDateTime(clock.date, "mm")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
