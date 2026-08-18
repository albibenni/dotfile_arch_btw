import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "albibenni.cpu"

  property int usage: -1

  function refresh() {
    if (!sampleProcess.running) sampleProcess.running = true
  }

  function applySamples(output) {
    var lines = String(output || "").trim().split("\n")
    if (lines.length !== 2) return

    var before = lines[0].trim().split(/\s+/).map(Number)
    var after = lines[1].trim().split(/\s+/).map(Number)
    if (before.length !== 2 || after.length !== 2) return

    var totalDelta = after[0] - before[0]
    var idleDelta = after[1] - before[1]
    if (totalDelta <= 0 || idleDelta < 0) return

    usage = Math.max(0, Math.min(100, Math.round((totalDelta - idleDelta) * 100 / totalDelta)))
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // Two short samples make CPU usage a rate, rather than a misleading total
  // since boot. The process is deliberately single-flight to avoid overlap.
  Process {
    id: sampleProcess
    command: [
      "bash", "-c",
      "awk '/^cpu / { total = 0; for (i = 2; i <= NF; i++) total += $i; print total, $5 + $6; exit }' /proc/stat; sleep 0.1; awk '/^cpu / { total = 0; for (i = 2; i <= NF; i++) total += $i; print total, $5 + $6; exit }' /proc/stat"
    ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applySamples(text)
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.usage < 0 ? "󰍛 --" : "󰍛 " + root.usage + "%"
    tooltipText: (root.usage < 0 ? "CPU usage: loading" : "CPU usage: " + root.usage + "%")
      + "\nLeft-click: btop\nRight-click: Ghostty"
    onPressed: function(button) {
      if (button === Qt.LeftButton) Quickshell.execDetached(["omarchy-launch-or-focus-tui", "btop"])
      else if (button === Qt.RightButton) Quickshell.execDetached(["ghostty"])
    }
  }
}
