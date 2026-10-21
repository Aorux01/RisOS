#!/usr/bin/env bash
# Fedora 44 switched KDE to Plasma Login Manager, which cannot load custom themes.
# RisOS goes back to SDDM, whose QML themes give full control over the login screen.
set -euxo pipefail

dnf remove -y plasma-login-manager

# Removing it must not have taken the desktop down with it.
rpm -q plasma-desktop plasma-workspace kwin

dnf install -y --setopt=install_weak_deps=False \
  sddm sddm-wayland-plasma sddm-breeze sddm-kcm

# Replace the display-manager alias that pointed to plasmalogin.service.
rm -f /etc/systemd/system/display-manager.service
systemctl enable sddm.service
systemctl disable plasmalogin.service 2>/dev/null || true
