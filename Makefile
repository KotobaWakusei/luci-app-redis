include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-redis
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

PKG_MAINTAINER:=KotobaWakusei <kotobawakusei@users.noreply.github.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-redis
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Redis Management
  DEPENDS:=+redis-server +luci-base
  URL:=https://github.com/KotobaWakusei/luci-app-redis
endef

define Package/luci-app-redis/description
  LuCI web interface for managing Redis server on OpenWrt routers.
  Provides real-time status monitoring, service control, command
  execution and key browsing.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-redis/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/redis
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./src/usr/lib/lua/luci/controller/redis.lua $(1)/usr/lib/lua/luci/controller/redis.lua
	$(INSTALL_DATA) ./src/usr/lib/lua/luci/view/redis/overview.htm $(1)/usr/lib/lua/luci/view/redis/overview.htm
	$(INSTALL_DATA) ./src/usr/share/rpcd/acl.d/luci-app-redis.json $(1)/usr/share/rpcd/acl.d/luci-app-redis.json
endef

$(eval $(call BuildPackage,luci-app-redis))