import Quickshell
import QtQuick

// Strings of the shell, in French and English. The language comes from the user's Plasma
// setting (read by status.sh), or from the environment until that is known.
QtObject {
    id: root

    property string lang: {
        var v = Quickshell.env("LANGUAGE") || Quickshell.env("LC_ALL") || Quickshell.env("LC_MESSAGES") || Quickshell.env("LANG") || "en"
        return v.substring(0, 2).toLowerCase()
    }

    readonly property var locale: Qt.locale(lang === "fr" ? "fr_FR" : "en_US")

    readonly property var fr: ({
        "about": "À propos de RisOS",
        "settings": "Réglages",
        "store": "Magasin",
        "lock": "Verrouiller l'écran",
        "sleep": "Mettre en veille",
        "restart": "Redémarrer",
        "shutdown": "Éteindre",
        "logout": "Fermer la session de %1",
        "wifi": "Wi-Fi",
        "bluetooth": "Bluetooth",
        "theme": "Thème",
        "light": "Clair",
        "dark": "Sombre",
        "on": "Activé",
        "off": "Désactivé",
        "disconnected": "Non connecté",
        "wired": "Câble",
        "search": "Chercher dans %1 applications",
        "no_result": "Aucune application trouvée",
        "new_window": "Nouvelle fenêtre",
        "open": "Ouvrir",
        "files": "Fichiers",
        "web": "Navigateur",
        "messages": "Messages",
        "phone": "Téléphone",
        "meet": "Visio",
        "notes": "Notes",
        "terminal": "Terminal",
        "apps": "Applications",
        "trash": "Corbeille"
    })

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
        "web": "Browser",
        "messages": "Messages",
        "phone": "Phone",
        "meet": "Meet",
        "notes": "Notes",
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

    function dateText(d, fmt) {
        return locale.toString(d, fmt)
    }
}
