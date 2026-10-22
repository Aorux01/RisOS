import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager

// Top bar: name of the active application in bold ("Fichiers" in the mockup),
// shown before its menus.
PlasmoidItem {
    id: root

    property string appName: "Desktop"
    readonly property real fontPx: Math.max(14, Math.round(height * 0.42))

    preferredRepresentation: fullRepresentation

    TaskManager.TasksModel {
        id: tasks
        groupMode: TaskManager.TasksModel.GroupDisabled
        onActiveTaskChanged: root.refresh()
        onDataChanged: root.refresh()
    }

    function refresh() {
        var index = tasks.activeTask
        if (index && index.valid) {
            var name = tasks.data(index, TaskManager.AbstractTasksModel.AppName)
            root.appName = name && name.length > 0 ? name : "Desktop"
        } else {
            root.appName = "Desktop"
        }
    }

    Component.onCompleted: refresh()

    fullRepresentation: Text {
        Layout.minimumWidth: implicitWidth + Math.round(root.fontPx * 0.8)
        Layout.preferredWidth: implicitWidth + Math.round(root.fontPx * 0.8)
        verticalAlignment: Text.AlignVCenter
        leftPadding: Math.round(root.fontPx * 0.4)
        rightPadding: Math.round(root.fontPx * 0.4)
        text: root.appName
        color: Kirigami.Theme.textColor
        font.family: "Figtree"
        font.pixelSize: root.fontPx
        font.weight: Font.Bold
        elide: Text.ElideRight
    }
}
