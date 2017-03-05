include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=hello
PKG_VERSION:=1
PKG_RELEASE:=1

TRUE_LINUX_VERSION=$(LINUX_VERSION)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/hello
  SUBMENU:=Wireless Drivers
  DEFAULT:=y
  TITLE:=Hello World
  KCONFIG:=CONFIG_hello=y
  FILES:=$(PKG_BUILD_DIR)/*.$(LINUX_KMOD_SUFFIX)
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) src/* $(PKG_BUILD_DIR)/
endef

define KernelPackage/hello/description
 This package contains a driver for Atheros chipsets.
endef

define KernelPackage/hello/install
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
	#$(INSTALL_DIR) $(1)/etc/init.d/
	#$(CP) files/inithello $(1)/etc/init.d/
endef

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)" \
	$(EXTRA_KCONFIG) \
	V=1

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,hello))
