import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: configRoot

    // Properties for configuration
    property alias cfg_colorHex: colorhex.text
    property alias cfg_dateFormat: dateFormatField.text
    property alias cfg_timeFormat: timeFormatField.text
    property alias cfg_timeZone: timeZoneComboBox.currentValue

    signal configurationChanged

    ColumnLayout {
        spacing: units.smallSpacing * 2

        // Color Selector
        ColumnLayout {
            Label {
                text: i18n("Color")
            }
            TextField {
                id: colorhex
                width: 200
                text: cfg_colorHex
                onTextChanged: configurationChanged()
            }
        }

        // Date Format Selector
        ColumnLayout {
            Label {
                text: i18n("Date Format")
            }
            ComboBox {
                id: dateFormatPresets
                Layout.fillWidth: true
                model: [
                    { text: "Weekday, Date Month (e.g., mon, 15 jan)", value: "ddd, d MMM" },
                    { text: "Full Weekday, Date Month (e.g., monday, 15 january)", value: "dddd, d MMMM" },
                    { text: "Numeric Short (e.g., 15/01/2024)", value: "dd/MM/yyyy" },
                    { text: "Numeric Long (e.g., 15 january 2024)", value: "d MMMM yyyy" },
                    { text: "Custom...", value: "custom" }
                ]
                textRole: "text"
                valueRole: "value"

                onCurrentValueChanged: {
                    if (currentValue !== "custom") {
                        dateFormatField.text = currentValue
                        dateFormatField.readOnly = true
                    } else {
                        dateFormatField.readOnly = false
                        dateFormatField.text = ""
                        dateFormatField.focus = true
                    }
                    configurationChanged()
                }
            }

            // Custom Date Format Input
            TextField {
                id: dateFormatField
                Layout.fillWidth: true
                readOnly: true
                placeholderText: i18n("Enter custom date format")
                onTextChanged: configurationChanged()
            }
        }

        // Time Format Selector
        ColumnLayout {
            Label {
                text: i18n("Time Format")
            }
            ComboBox {
                id: timeFormatPresets
                Layout.fillWidth: true
                model: [
                    { text: "24-Hour (e.g., 15:45)", value: "HH:mm" },
                    { text: "12-Hour with AM/PM (e.g., 3:45 PM)", value: "h:mm AP" },
                    { text: "Custom...", value: "custom" }
                ]
                textRole: "text"
                valueRole: "value"

                onCurrentValueChanged: {
                    if (currentValue !== "custom") {
                        timeFormatField.text = currentValue
                        timeFormatField.readOnly = true
                    } else {
                        timeFormatField.readOnly = false
                        timeFormatField.text = ""
                        timeFormatField.focus = true
                    }
                    configurationChanged()
                }
            }

            // Custom Time Format Input
            TextField {
                id: timeFormatField
                Layout.fillWidth: true
                readOnly: true
                placeholderText: i18n("Enter custom time format")
                onTextChanged: configurationChanged()
            }
        }

        // Time Zone Selector
        ColumnLayout {
            Label {
                text: i18n("Time Zone")
            }
            ComboBox {
                id: timeZoneComboBox
                Layout.fillWidth: true
                // Curated list of major timezones
                model: [
                    { text: "Local System Time", value: "Local" },
                    { text: "UTC", value: "UTC" },
                    { text: "UTC-12:00", value: "Etc/GMT+12" },
                    { text: "UTC-11:00 (Midway)", value: "Pacific/Midway" },
                    { text: "UTC-10:00 (Hawaii)", value: "Pacific/Honolulu" },
                    { text: "UTC-09:30 (Marquesas)", value: "Pacific/Marquesas" },
                    { text: "UTC-09:00 (Alaska)", value: "America/Anchorage" },
                    { text: "UTC-08:00 (Los Angeles - PST/PDT)", value: "America/Los_Angeles" },
                    { text: "UTC-08:00 (Tijuana)", value: "America/Tijuana" },
                    { text: "UTC-07:00 (Denver - MST/MDT)", value: "America/Denver" },
                    { text: "UTC-07:00 (Phoenix)", value: "America/Phoenix" },
                    { text: "UTC-06:00 (Chicago - CST/CDT)", value: "America/Chicago" },
                    { text: "UTC-06:00 (Mexico City)", value: "America/Mexico_City" },
                    { text: "UTC-06:00 (Saskatchewan)", value: "America/Regina" },
                    { text: "UTC-05:00 (New York - EST/EDT)", value: "America/New_York" },
                    { text: "UTC-05:00 (Bogota)", value: "America/Bogota" },
                    { text: "UTC-05:00 (Lima)", value: "America/Lima" },
                    { text: "UTC-04:00 (Santiago)", value: "America/Santiago" },
                    { text: "UTC-04:00 (Caracas)", value: "America/Caracas" },
                    { text: "UTC-04:00 (Halifax)", value: "America/Halifax" },
                    { text: "UTC-03:30 (Newfoundland)", value: "America/St_Johns" },
                    { text: "UTC-03:00 (Sao Paulo - BRT/BRST)", value: "America/Sao_Paulo" },
                    { text: "UTC-03:00 (Buenos Aires)", value: "America/Buenos_Aires" },
                    { text: "UTC-03:00 (Greenland)", value: "America/Godthab" },
                    { text: "UTC-02:00 (South Georgia)", value: "Atlantic/South_Georgia" },
                    { text: "UTC-02:00 (General)", value: "Etc/GMT+2" },
                    { text: "UTC-01:00 (Azores)", value: "Atlantic/Azores" },
                    { text: "UTC-01:00 (Cape Verde)", value: "Atlantic/Cape_Verde" },
                    { text: "UTC+00:00 (London - GMT/BST)", value: "Europe/London" },
                    { text: "UTC+00:00 (Lisbon)", value: "Europe/Lisbon" },
                    { text: "UTC+00:00 (Casablanca)", value: "Africa/Casablanca" },
                    { text: "UTC+01:00 (Paris - CET/CEST)", value: "Europe/Paris" },
                    { text: "UTC+01:00 (Berlin)", value: "Europe/Berlin" },
                    { text: "UTC+01:00 (Rome)", value: "Europe/Rome" },
                    { text: "UTC+01:00 (Lagos)", value: "Africa/Lagos" },
                    { text: "UTC+02:00 (Athens)", value: "Europe/Athens" },
                    { text: "UTC+02:00 (Cairo)", value: "Africa/Cairo" },
                    { text: "UTC+02:00 (Jerusalem)", value: "Asia/Jerusalem" },
                    { text: "UTC+02:00 (Helsinki)", value: "Europe/Helsinki" },
                    { text: "UTC+02:00 (Johannesburg)", value: "Africa/Johannesburg" },
                    { text: "UTC+03:00 (Moscow)", value: "Europe/Moscow" },
                    { text: "UTC+03:00 (Istanbul)", value: "Europe/Istanbul" },
                    { text: "UTC+03:00 (Nairobi)", value: "Africa/Nairobi" },
                    { text: "UTC+03:00 (Baghdad)", value: "Asia/Baghdad" },
                    { text: "UTC+03:00 (Riyadh)", value: "Asia/Riyadh" },
                    { text: "UTC+03:30 (Tehran)", value: "Asia/Tehran" },
                    { text: "UTC+04:00 (Dubai)", value: "Asia/Dubai" },
                    { text: "UTC+04:00 (Baku)", value: "Asia/Baku" },
                    { text: "UTC+04:30 (Kabul)", value: "Asia/Kabul" },
                    { text: "UTC+05:00 (Karachi)", value: "Asia/Karachi" },
                    { text: "UTC+05:00 (Tashkent)", value: "Asia/Tashkent" },
                    { text: "UTC+05:30 (Kolkata)", value: "Asia/Kolkata" },
                    { text: "UTC+05:30 (Colombo)", value: "Asia/Colombo" },
                    { text: "UTC+05:45 (Kathmandu)", value: "Asia/Kathmandu" },
                    { text: "UTC+06:00 (Dhaka)", value: "Asia/Dhaka" },
                    { text: "UTC+06:00 (Almaty)", value: "Asia/Almaty" },
                    { text: "UTC+06:30 (Yangon)", value: "Asia/Yangon" },
                    { text: "UTC+07:00 (Bangkok)", value: "Asia/Bangkok" },
                    { text: "UTC+07:00 (Jakarta)", value: "Asia/Jakarta" },
                    { text: "UTC+07:00 (Novosibirsk)", value: "Asia/Novosibirsk" },
                    { text: "UTC+08:00 (Singapore)", value: "Asia/Singapore" },
                    { text: "UTC+08:00 (Shanghai)", value: "Asia/Shanghai" },
                    { text: "UTC+08:00 (Taipei)", value: "Asia/Taipei" },
                    { text: "UTC+08:00 (Hong Kong)", value: "Asia/Hong_Kong" },
                    { text: "UTC+08:00 (Perth)", value: "Australia/Perth" },
                    { text: "UTC+09:00 (Tokyo)", value: "Asia/Tokyo" },
                    { text: "UTC+09:00 (Seoul)", value: "Asia/Seoul" },
                    { text: "UTC+09:30 (Adelaide)", value: "Australia/Adelaide" },
                    { text: "UTC+09:30 (Darwin)", value: "Australia/Darwin" },
                    { text: "UTC+10:00 (Sydney)", value: "Australia/Sydney" },
                    { text: "UTC+10:00 (Brisbane)", value: "Australia/Brisbane" },
                    { text: "UTC+10:00 (Vladivostok)", value: "Asia/Vladivostok" },
                    { text: "UTC+11:00 (Noumea)", value: "Pacific/Noumea" },
                    { text: "UTC+12:00 (Auckland)", value: "Pacific/Auckland" },
                    { text: "UTC+12:00 (Fiji)", value: "Pacific/Fiji" },
                    { text: "UTC+13:00 (Tongatapu)", value: "Pacific/Tongatapu" },
                    { text: "UTC+14:00 (Kiritimati)", value: "Pacific/Kiritimati" }
                ]
                textRole: "text"
                valueRole: "value"
                onCurrentValueChanged: configurationChanged()
            }
        }

        // Tip Text
        Label {
            text: i18n("Format Help: Use Qt date formatting codes (ddd, MMM, HH, mm, etc.)")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
    }
}
