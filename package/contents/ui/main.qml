import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support as Plasma5Support
import "TimeZoneData.js" as TimeZoneData
    PlasmoidItem {
        id: root

    property color colorPlasmoid: Plasmoid.configuration.colorHex

    // Transparent background
    Plasmoid.backgroundHints: "NoBackground"

    // Font loaders with more robust path handling
    FontLoader {
        id: poppinsThin
        source: Qt.resolvedUrl("../fonts/poppins-thin.ttf")
    }

    FontLoader {
        id: poppinsRegular
        source: Qt.resolvedUrl("../fonts/poppins-regular.ttf")
    }

    property var currentDateTime: new Date()

    property string activeTimeZone: Plasmoid.configuration.timeZone
    property int timeZoneOffset: 0

    property var displayDateTime: {
        // If Local, just return current time
        if (activeTimeZone === "Local" || activeTimeZone === "") {
            return currentDateTime
        }
        
        // Manual Shift Strategy:
        // DateTime from DataEngine is the correct "Moment" (UTC-based).
        // Qt.formatDateTime uses System Local Timezone.
        // We want: Format(ShiftedDate) in Local = Remote Time String.
        // UTC(Shifted) + LocalOffset = UTC(Real) + RemoteOffset.
        // Shifted = Real + RemoteOffset - LocalOffset.
        
        var localOffsetMin = new Date().getTimezoneOffset() // (UTC - Local) in minutes. e.g. Brazil(+3h because 180).
        // Actually getTimezoneOffset returns positive if behind UTC. 
        // Brazil (GMT-3) -> 180. London (GMT+1) -> -60.
        // LocalOffsetSeconds = -1 * localOffsetMin * 60.
        
        var localOffsetSeconds = -localOffsetMin * 60
        var targetOffsetSeconds = root.timeZoneOffset
        
        var diffSeconds = targetOffsetSeconds - localOffsetSeconds
        
        return new Date(currentDateTime.getTime() + diffSeconds * 1000)
    }

    Plasma5Support.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: [activeTimeZone === "Local" ? "Local" : activeTimeZone]
        interval: 60000
        onDataChanged: function(sourceName, data) {

            
            if (sourceName === activeTimeZone || (activeTimeZone === "Local" && sourceName === "Local")) {
                if (data["DateTime"]) {
                    root.currentDateTime = data["DateTime"]
                }
                if (data["Offset"] !== undefined) {
                    root.timeZoneOffset = data["Offset"]
                }
            }
        }
    }

    // Force update when timezone changes
    Connections {
        target: Plasmoid.configuration
        function onTimeZoneChanged() {
            var src = Plasmoid.configuration.timeZone
            root.activeTimeZone = src
            
            // Reconnect logic is handled by binding on connectedSources, 
            // but we want to update data immediately if possible.
            
            var engineSource = src === "Local" ? "Local" : src
            
            if (timeSource.data[engineSource]) {
                if (timeSource.data[engineSource]["DateTime"]) {
                    root.currentDateTime = timeSource.data[engineSource]["DateTime"]
                }
                if (timeSource.data[engineSource]["Offset"] !== undefined) {
                    root.timeZoneOffset = timeSource.data[engineSource]["Offset"]
                }
            }
        }
    }
    
    // Timer to update UI every second locally if needed, or rely on DataSource (minutely)
    // The previous code had 60000 interval. DataSource also has 60000.
    
    // Centered layout container
    Item {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 10

        // Vertical layout for better alignment
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width
            spacing: 2

            // Date Text (small, centered)
            Text {
                id: dateText
                Layout.alignment: Qt.AlignHCenter
                font.family: poppinsThin.name
                font.pixelSize: root.height * 0.1
                text: root.displayDateTime.toLocaleString(Qt.locale(), Plasmoid.configuration.dateFormat).toLowerCase()
                color: colorPlasmoid
                horizontalAlignment: Text.AlignHCenter
            }

            // Time Text (large, centered)
            Text {
                id: timeText
                Layout.alignment: Qt.AlignHCenter
                font.family: poppinsRegular.name
                font.pixelSize: root.height * 0.4
                text: root.displayDateTime.toLocaleString(Qt.locale(), Plasmoid.configuration.timeFormat)
                color: colorPlasmoid
                horizontalAlignment: Text.AlignHCenter
            }

            // Time Zone Label
            Text {
                id: timeZoneText
                Layout.alignment: Qt.AlignHCenter
                font.family: poppinsThin.name
                font.pixelSize: root.height * 0.07
                text: {
                    var tz = root.activeTimeZone;
                    if (tz === "Local" || tz === "") return "";
                    for (var i = 0; i < TimeZoneData.timeZones.length; i++) {
                        if (TimeZoneData.timeZones[i].value === tz) {
                            return TimeZoneData.timeZones[i].text;
                        }
                    }
                    return tz;
                }
                color: colorPlasmoid
                horizontalAlignment: Text.AlignHCenter
                visible: root.activeTimeZone !== "Local" && root.activeTimeZone !== ""
            }



        }
    }
}
