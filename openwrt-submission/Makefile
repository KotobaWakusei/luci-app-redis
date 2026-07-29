#
# Copyright (C) 2026 KotobaWakusei <kotobawakusei@users.noreply.github.com>
#
# This is free software, licensed under MIT.
#

include $(TOPDIR)/rules.mk

PKG_LICENSE:=MIT

LUCI_TITLE:=LuCI Redis Management
LUCI_DESCRIPTION:=LuCI web interface for managing Redis server. \
	Provides real-time status monitoring, service control, \
	command execution and key browsing.
LUCI_DEPENDS:=+redis-server +luci-base
LUCI_PKGARCH:=all

PKG_VERSION:=1.0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=KotoraWakusei <kotobawakusei@users.noreply.github.com>

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature