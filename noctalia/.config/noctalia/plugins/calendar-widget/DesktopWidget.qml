import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
    id: root
    property var pluginApi: null

	readonly property bool startOnMonday: pluginApi?.pluginSettings?.startOnMonday ?? true
	// --- Sizing ---
    readonly property real _width: Math.round(250 * widgetScale)
    readonly property real _height: Math.round(285 * widgetScale)
    implicitWidth: _width
    implicitHeight: _height

    // --- Date Logic ---
    property date currentDate: new Date()
    
    function refreshDate() {
        currentDate = new Date();
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.refreshDate()
    }

    // UPDATED: Now reacts to startOnMonday
    readonly property var days: startOnMonday 
        ? ["M", "T", "W", "T", "F", "S", "S"] 
        : ["S", "M", "T", "W", "T", "F", "S"]
    
    // UPDATED: Now calculates offset based on startOnMonday
    readonly property int firstDayOffset: {
        let firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
        if (startOnMonday) {
            // Monday start: (Sun=0 -> 6, Mon=1 -> 0, etc.)
            return (firstDay === 0) ? 6 : firstDay - 1;
        } else {
            // Sunday start: (Sun=0 -> 0, Mon=1 -> 1, etc.)
            return firstDay;
        }
    }

    readonly property int daysInMonth: new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate()
    
    function isToday(dayNum) {
        let now = new Date();
        return dayNum === now.getDate() && 
               currentDate.getMonth() === now.getMonth() && 
               currentDate.getFullYear() === now.getFullYear();
    }

    // --- UI Layout ---
    Rectangle {
        anchors.fill: parent
        color: Color.mSurface 
        opacity: 0.85
        radius: Style.radiusM
        border.color: Color.mOutlineVariant
        border.width: 1

        // --- Themed Refresh Button ---
        Rectangle {
            id: refreshBtn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Style.marginS
            width: 32 * widgetScale
            height: 32 * widgetScale
            radius: Style.radiusS
            color: mouseArea.containsMouse ? Color.mPrimaryContainer : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
            
            Canvas {
                id: refreshIcon
                anchors.fill: parent
                anchors.margins: 8 * widgetScale
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = mouseArea.containsMouse ? Color.mOnPrimaryContainer : Color.mPrimary;
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.arc(width/2, height/2, width/2 - 2, 0, Math.PI * 1.5);
                    ctx.stroke();
                    ctx.fillStyle = ctx.strokeStyle;
                    ctx.beginPath();
                    ctx.moveTo(width/2, 0);
                    ctx.lineTo(width/2 + 4, 4);
                    ctx.lineTo(width/2 - 4, 4);
                    ctx.closePath();
                    ctx.fill();
                }
                Connections {
                    target: mouseArea
                    function onContainsMouseChanged() { refreshIcon.requestPaint(); }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.refreshDate()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginL
            spacing: Style.marginS

            NText {
                text: currentDate.toLocaleDateString(Qt.locale(), "MMMM yyyy").toUpperCase()
                color: Color.mPrimary 
                font.bold: true
                font.letterSpacing: 1.2
                font.pointSize: Style.fontSizeM
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 7
                rowSpacing: Style.marginS
                columnSpacing: Style.marginS
                Layout.fillWidth: true

                Repeater {
                    model: root.days
                    NText {
                        text: modelData
                        color: Color.mOnSurfaceVariant
                        font.bold: true
                        font.pointSize: Style.fontSizeS
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Repeater {
                    model: root.firstDayOffset
                    Item { Layout.preferredWidth: 20 * widgetScale; Layout.preferredHeight: 20 * widgetScale }
                }

                Repeater {
                    model: root.daysInMonth
                    Rectangle {
                        readonly property int dayNum: index + 1
                        readonly property bool highlight: root.isToday(dayNum)
                        Layout.preferredWidth: 28 * widgetScale
                        Layout.preferredHeight: 28 * widgetScale
                        color: highlight ? Color.mPrimary : "transparent"
                        radius: Style.radiusS
                        NText {
                            anchors.centerIn: parent
                            text: dayNum
                            color: highlight ? Color.mOnPrimary : Color.mOnSurface
                            font.bold: highlight
                            font.pointSize: Style.fontSizeS
                        }
                    }
                }
            }
        }
    }
}
