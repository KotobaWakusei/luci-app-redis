# Maintainer: KotobaWakusei <kotobawakusei@users.noreply.github.com>
pkgname=luci-app-redis
pkgver=1.0.0
pkgrel=1
pkgdesc="LuCI web interface for managing Redis server on OpenWrt"
url="https://github.com/KotobaWakusei/luci-app-redis"
arch="noarch"
license="MIT"
depends="lua5.3 luci base-files redis"
makedepends=""
source="luci-app-redis-${pkgver}.tar.gz"
builddir=""

package() {
	mkdir -p "$pkgdir"
	cp -a src/* "$pkgdir"/
}