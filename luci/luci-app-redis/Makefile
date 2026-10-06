# SPDX-License-Identifier: MIT

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-redis
PKG_VERSION:=2026.10.06~8d6659f
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/KotobaWakusei/luci-app-redis.git
PKG_SOURCE_DATE:=2026-10-06
PKG_SOURCE_VERSION:=8d6659ffc9af8abced1552d1b2983638f9800974
PKG_MIRROR_HASH:=

PKG_MAINTAINER:=KotobaWakusei <kotobawakusei@users.noreply.github.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-redis
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Redis Management
  URL:=https://github.com/KotobaWakusei/luci-app-redis
  DEPENDS:=+luci-base +luci-lua-runtime +redis-server +redis-cli
  PKGARCH:=all
endef

define Package/luci-app-redis/description
  LuCI web interface for managing Redis server on OpenWrt.
  Provides status monitoring, service control, Redis command execution,
  and key browsing.
endef

define Package/luci-app-redis/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/redis
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/usr/lib/lua/luci/controller/redis.lua $(1)/usr/lib/lua/luci/controller/redis.lua
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/usr/lib/lua/luci/view/redis/overview.htm $(1)/usr/lib/lua/luci/view/redis/overview.htm
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/usr/share/rpcd/acl.d/luci-app-redis.json $(1)/usr/share/rpcd/acl.d/luci-app-redis.json
endef

$(eval $(call BuildPackage,luci-app-redis))
