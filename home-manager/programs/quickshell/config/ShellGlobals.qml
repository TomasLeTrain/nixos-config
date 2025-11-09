pragma Singleton

import QtQuick
import Quickshell

Singleton {
	readonly property var colors: QtObject {
		readonly property color fg: "#cdcdcd";
		readonly property color second_fg: "#0a0a0f";
		readonly property color bar: "#141415";
		readonly property color barOutline: "#00878787";

		readonly property color blue: "#6e94b2";
		readonly property color red: "#d8647e";
		readonly property color green: "#7fa563";

		// readonly property color widget: "#25ceffff";
		// readonly property color widgetActive: "#80ceffff";
		// readonly property color widgetOutline: "#40ffffff";
		// readonly property color widgetOutlineSeparate: "#20ffffff";
		readonly property color separator: "#60ffffff";
	}

	function interpolateColors(x: real, a: color, b: color): color {
		const xa = 1.0 - x;
		return Qt.rgba(a.r * xa + b.r * x, a.g * xa + b.g * x, a.b * xa + b.b * x, a.a * xa + b.a * x);
	}
}

