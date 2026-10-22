#!/usr/bin/env bash
# (Re)start the RisOS shell: the top bar and the dock, written in QML for Quickshell.
pkill -x quickshell 2>/dev/null
exec quickshell -p /usr/share/risos/shell
