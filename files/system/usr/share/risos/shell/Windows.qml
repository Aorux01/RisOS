import QtQuick
import org.kde.taskmanager as TaskManager

// Window list for the shell, read through the library Plasma's own task manager uses
// (KWin does not expose wlr-foreign-toplevel). Loaded through a Loader: if the module is
// missing, the bar and the dock still work, only without running indicators.
Item {
    id: root

    property string activeAppId: ""
    property string activeName: ""
    property bool activeMaximized: false
    property bool activeFullscreen: false
    property var counts: ({})   // app id (lowercase, no ".desktop") -> number of windows

    TaskManager.TasksModel {
        id: tasks
        groupMode: TaskManager.TasksModel.GroupDisabled
    }

    function norm(id) {
        return (id || "").toString().toLowerCase().replace(/\.desktop$/, "")
    }

    function refresh() {
        var c = {}
        var active = ""
        var name = ""
        var maximized = false
        var fullscreen = false
        for (var i = 0; i < tasks.count; i++) {
            var idx = tasks.index(i, 0)
            var id = norm(tasks.data(idx, TaskManager.AbstractTasksModel.AppId))
            if (id === "")
                continue
            c[id] = (c[id] || 0) + 1
            if (tasks.data(idx, TaskManager.AbstractTasksModel.IsActive)) {
                active = id
                name = tasks.data(idx, TaskManager.AbstractTasksModel.AppName) || ""
                maximized = !!tasks.data(idx, TaskManager.AbstractTasksModel.IsMaximized)
                fullscreen = !!tasks.data(idx, TaskManager.AbstractTasksModel.IsFullScreen)
            }
        }
        counts = c
        activeAppId = active
        activeName = name
        activeMaximized = maximized
        activeFullscreen = fullscreen
    }

    Timer {
        interval: 700
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
