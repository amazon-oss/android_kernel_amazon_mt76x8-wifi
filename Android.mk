LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
MT76X8_WLAN_PATH := kernel/amazon/mt76x8-wifi

include $(CLEAR_VARS)

LOCAL_MODULE        := mt76x8_wlan
LOCAL_MODULE_SUFFIX := .ko
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR)/lib/modules

_mt76x8_wlan_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_mt76x8_wlan_mod_name := $(LOCAL_MODULE)
_mt76x8_wlan_ko := $(_mt76x8_wlan_intermediates)/$(_mt76x8_wlan_mod_name)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_OUT_RELATIVE := ../../KERNEL_OBJ

$(_mt76x8_wlan_ko): $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@mkdir -p $(KERNEL_MODULES_OUT)/lib/modules
	@cp -R $(MT76X8_WLAN_PATH)/module/* $(_mt76x8_wlan_intermediates)/
	@cp -f $(MT76X8_WLAN_PATH)/configs/$(TARGET_DEVICE).config $(_mt76x8_wlan_intermediates)/.config
	$(hide) +$(MAKE) -C $(KERNEL_OUT) M=$(abspath $(_mt76x8_wlan_intermediates)) ARCH=$(TARGET_KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) MODULE_NAME=$(_mt76x8_wlan_mod_name) modules
	modules=$$(find $(_mt76x8_wlan_intermediates) -type f -name '*.ko'); \
	for f in $$modules; do \
		$(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $$f; \
		cp $$f $(KERNEL_MODULES_OUT)/lib/modules; \
	done;
	touch $(_mt76x8_wlan_ko)

include $(BUILD_SYSTEM)/base_rules.mk
endif
