import Quickshell
import QtQuick

// Strings of the shell, in French and English. The language comes from the user's Plasma
// setting (read by status.sh), or from the environment until that is known.
QtObject {
    id: root

    // French catalog (StringsFr.qml). Add a language by adding a catalog and a case in t().
    property QtObject catalogFr: StringsFr {}

    property string lang: {
        var v = Quickshell.env("LANGUAGE") || Quickshell.env("LC_ALL") || Quickshell.env("LC_MESSAGES") || Quickshell.env("LANG") || "en"
        return v.substring(0, 2).toLowerCase()
    }

    readonly property var locale: Qt.locale(lang === "fr" ? "fr_FR" : "en_US")

    readonly property var fr: catalogFr.strings

    readonly property var en: ({
        "about": "About RisOS",
        "settings": "Settings",
        "store": "Store",
        "lock": "Lock screen",
        "sleep": "Sleep",
        "restart": "Restart",
        "shutdown": "Shut down",
        "logout": "Close %1's session",
        "wifi": "Wi-Fi",
        "bluetooth": "Bluetooth",
        "password": "Password",
        "wrong_password": "Incorrect password",
        "dnd": "Do not disturb",
        "unavailable": "Unavailable",
        "theme": "Theme",
        "light": "Light",
        "dark": "Dark",
        "on": "On",
        "off": "Off",
        "disconnected": "Not connected",
        "wired": "Wired",
        "search": "Search %1 apps",
        "no_result": "No app found",
        "new_window": "New window",
        "open": "Open",
        "files": "Files",
        "web": "Firefox",
        "photos": "Photos",
        "editor": "Text editor",
        "calculator": "Calculator",
        "terminal": "Terminal",
        "apps": "Apps",
        "trash": "Trash"
    })

    // Translate a key; "%1" is replaced by the optional argument.
    function t(key, arg) {
        var d = lang === "fr" ? fr : en
        var s = d[key] !== undefined ? d[key] : key
        return arg !== undefined ? s.replace("%1", arg) : s
    }

    // RisOS name of the base apps (desktop id -> key); every other app keeps its own name.
    readonly property var baseNames: ({
        "org.kde.dolphin": "files",
        "org.kde.discover": "store",
        "org.kde.konsole": "terminal",
        "systemsettings": "settings",
        "org.kde.gwenview": "photos",
        "org.kde.kate": "editor",
        "org.kde.kcalc": "calculator"
    })

    function appName(entry) {
        var id = (entry.id || "").replace(/\.desktop$/, "")
        var key = baseNames[id]
        return key ? t(key) : entry.name
    }

    function dateText(d, fmt) {
        return locale.toString(d, fmt)
    }
}
