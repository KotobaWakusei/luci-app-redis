include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-redis
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=KotobaWakusei <kotobawakusei@users.noreply.github.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/luci-app-redis
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Redis Management for LuCI
  DEPENDS:=+redisServer +lua +luci-base
  URL:=https://github.com/KotobaWakusei/luci-app-redis
endef

define Package/luci-app-redis/description
  LuCI web interface for managing Redis server on OpenWrt routers.
  Provides real-time status monitoring, service control, and key management.
endef

define Build/Compile
endef

define Package/luci-app-redis/install
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/
endef

$(eval $(call BuildPackage,luci-app-redis))