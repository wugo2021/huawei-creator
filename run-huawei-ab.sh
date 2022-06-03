#!/bin/bash

#Usage:
#sudo bash run-huawei.sh [/path/to/system.img] [version]

#cleanups
umount d

set -ex

origin="$(readlink -f -- "$0")"
origin="$(dirname "$origin")"

[ ! -d vendor_vndk ] && git clone https://github.com/phhusson/vendor_vndk -b android-10.0

targetArch=64
srcFile="$1"
versionNumber="$2"


if [ ! -f "$srcFile" ];then
	echo "Usage: sudo bash run-huawei.sh [/path/to/system.img]"
	exit 1
fi

"$origin"/simg2img "$srcFile" s-ab.img || cp "$srcFile" s-ab.img

rm -Rf tmp
mkdir -p d tmp
e2fsck -y -f s-ab.img
resize2fs s-ab.img 4500M
e2fsck -E unshare_blocks -y -f s-ab.img
mount -o loop,rw s-ab.img d
(
	cd d/system
		

	#-----------------------------------------------------------------------------------	
		
	
	# rw-system custom for Huawei device
	cp "$origin/files-patch/system/bin/rw-system.sh" bin/rw-system.sh
	xattr -w security.selinux u:object_r:phhsu_exec:s0 bin/rw-system.sh

	# offline charging
	for img in $(cd "$origin/files-patch/system/etc/charger/1080x1920"; echo *);do
		cp "$origin/files-patch/system/etc/charger/1080x1920/$img" etc/charger/1080x1920/$img
		xattr -w security.selinux u:object_r:system_file:s0 etc/charger/1080x1920/$img
	done
	for img in $(cd "$origin/files-patch/system/etc/charger/1080x2160"; echo *);do
		cp "$origin/files-patch/system/etc/charger/1080x2160/$img" etc/charger/1080x2160/$img
		xattr -w security.selinux u:object_r:system_file:s0 etc/charger/1080x2160/$img
	done
	
	# NFC 
	cp "$origin/files-patch/system/etc/libnfc-brcm.conf" etc/libnfc-brcm.conf
	xattr -w security.selinux u:object_r:system_file:s0  etc/libnfc-brcm.conf
	cp "$origin/files-patch/system/etc/libnfc-nci.conf" etc/libnfc-nci.conf
	xattr -w security.selinux u:object_r:system_file:s0 etc/libnfc-nci.conf
	cp "$origin/files-patch/system/etc/libnfc-nxp.conf" etc/libnfc-nxp.conf
	xattr -w security.selinux u:object_r:system_file:s0 etc/libnfc-nxp.conf
	cp "$origin/files-patch/system/etc/libnfc-nxp_RF.conf" etc/libnfc-nxp_RF.conf
	xattr -w security.selinux u:object_r:system_file:s0 etc/libnfc-nxp_RF.conf
	
	cp "$origin/files-patch/system/etc/libnfc-brcm.conf" product/etc/libnfc-brcm.conf
	xattr -w security.selinux u:object_r:system_file:s0  product/etc/libnfc-brcm.conf
	cp "$origin/files-patch/system/etc/libnfc-nci.conf" product/etc/libnfc-nci.conf
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/libnfc-nci.conf
	cp "$origin/files-patch/system/etc/libnfc-nxp.conf" product/etc/libnfc-nxp.conf
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/libnfc-nxp.conf
	cp "$origin/files-patch/system/etc/libnfc-nxp_RF.conf" product/etc/libnfc-nxp_RF.conf
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/libnfc-nxp_RF.conf	
	
	# NFC permission
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.hce.xml" etc/permissions/android.hardware.nfc.hce.xml
	xattr -w security.selinux u:object_r:system_file:s0 etc/permissions/android.hardware.nfc.hce.xml 
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.hcef.xml" etc/permissions/android.hardware.nfc.hcef.xml
	xattr -w security.selinux u:object_r:system_file:s0 etc/permissions/android.hardware.nfc.hcef.xml
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.xml" etc/permissions/android.hardware.nfc.xml
	xattr -w security.selinux u:object_r:system_file:s0 etc/permissions/android.hardware.nfc.xml
	cp "$origin/files-patch/system/etc/permissions/com.android.nfc_extras.xml" etc/permissions/com.android.nfc_extras.xml
	xattr -w security.selinux u:object_r:system_file:s0 etc/permissions/com.android.nfc_extras.xml

	# NFC product permission
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.hce.xml" product/etc/permissions/android.hardware.nfc.hce.xml
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/permissions/android.hardware.nfc.hce.xml 
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.hcef.xml" product/etc/permissions/android.hardware.nfc.hcef.xml
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/permissions/android.hardware.nfc.hcef.xml
	cp "$origin/files-patch/system/etc/permissions/android.hardware.nfc.xml" product/etc/permissions/android.hardware.nfc.xml
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/permissions/android.hardware.nfc.xml
	cp "$origin/files-patch/system/etc/permissions/com.android.nfc_extras.xml" product/etc/permissions/com.android.nfc_extras.xml
	xattr -w security.selinux u:object_r:system_file:s0 product/etc/permissions/com.android.nfc_extras.xml
	
	# Codec bluetooth 32 bits
	cp "$origin/files-patch/system/lib/libaptX_encoder.so" lib/libaptX_encoder.so
	xattr -w security.selinux u:object_r:system_lib_file:s0 lib/libaptX_encoder.so
	cp "$origin/files-patch/system/lib/libaptXHD_encoder.so" lib/libaptXHD_encoder.so
	xattr -w security.selinux u:object_r:system_lib_file:s0 lib/libaptXHD_encoder.so
	
	# Codec bluetooth 64 bits
	cp "$origin/files-patch/system/lib64/libaptX_encoder.so" lib64/libaptX_encoder.so
	xattr -w security.selinux u:object_r:system_lib_file:s0 lib64/libaptX_encoder.so
	cp "$origin/files-patch/system/lib64/libaptXHD_encoder.so" lib64/libaptXHD_encoder.so
	xattr -w security.selinux u:object_r:system_lib_file:s0 lib64/libaptXHD_encoder.so
		
	# Fingerprint 
	cp "$origin/files-patch/system/phh/huawei/fingerprint.kl" phh/huawei/fingerprint.kl
	xattr -w security.selinux u:object_r:system_file:s0  phh/huawei/fingerprint.kl
	
	# Media Extractor policy (sas-creator run.sh add this two values)
	# getdents64: 1
	# rt_sigprocmask: 1	
	
	# Fix app crashes
	echo "(allow appdomain vendor_file (file (read getattr execute open)))" >> etc/selinux/plat_sepolicy.cil

	# Fix instagram denied 
    	echo "(allow untrusted_app dalvikcache_data_file (file (execmod)))" >> etc/selinux/plat_sepolicy.cil
    	echo "(allow untrusted_app proc_zoneinfo (file (read open)))" >> etc/selinux/plat_sepolicy.cil

	# Fix Google GMS denied 
    	echo "(allow gmscore_app splash2_data_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
    	echo "(allow gmscore_app teecd_data_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
    	echo "(allow gmscore_app modem_fw_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
    	echo "(allow gmscore_app modem_nv_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil


   	echo "debug.sf.latch_unsignaled=1" >> build.prop
	echo "ro.surface_flinger.running_without_sync_framework=true" >> build.prop;

		
	# Dirty hack to show build properties
	# To get productid : sed -nE 's/.*productid=([0-9xa-f]*).*/\1/p' /proc/cmdline
	#MODEL=$( cat /sys/firmware/devicetree/base/boardinfo/normal_product_name | tr -d '\n')
	MODEL="ANE-LX1"


	echo "#" >> etc/prop.default
    	echo "## Adding build props" >> etc/prop.default
    	echo "#" >> etc/prop.default
    	cat build.prop | grep "." >> etc/prop.default
    
	echo "#" >> etc/prop.default
	echo "## Adding hi6250 props" >> etc/prop.default
    	echo "#" >> etc/prop.default

	# adb root by default    	
    	#sed -i 's/^ro.secure=1/ro.secure=0/' etc/prop.default
    		
    	sed -i "/ro.product.model/d" etc/prop.default
    	sed -i "/ro.product.system.model/d" etc/prop.default
    	echo "ro.product.manufacturer=HUAWEI" >> etc/prop.default
    	echo "ro.product.system.model=hi6250" >> etc/prop.default
    	echo "ro.product.model=$MODEL" >> etc/prop.default
    	
    	#VERSION="LineageOS 18.1 LeaOS (CGMod)"
    	#VERSION="crDRom v314 - Mod Iceows"
    	#VERSION="LiR v314 - Mod Iceows"
    	#VERSION="dotOS-R 5.2 - Mod Iceows"
    	VERSION=$versionNumber
    	
    	sed -i "/ro.lineage.version/d" etc/prop.default;
    	sed -i "/ro.lineage.display.version/d" etc/prop.default;
    	sed -i "/ro.modversion/d" etc/prop.default;
    	echo "ro.lineage.version=$VERSION" >> etc/prop.default;
    	echo "ro.lineage.display.version=$VERSION" >> etc/prop.default;
    	echo "ro.modversion=$VERSION" >> etc/prop.default;
	 
	echo "persist.sys.usb.config=hisuite,mtp,mass_storage" >> etc/prop.default
    	echo "sys.usb.config=mtp" >> etc/prop.default
	echo "sys.usb.configfs=1" >> etc/prop.default
	echo "sys.usb.controller=hisi-usb-otg" >> etc/prop.default
	echo "sys.usb.ffs.aio_compat=true" >> etc/prop.default
   	echo "sys.usb.ffs.ready=0" >> etc/prop.default
	echo "sys.usb.ffs_hdb.ready=0" >> etc/prop.default
   	echo "sys.usb.state=mtp" >> etc/prop.default
   	

	#echo "ro.secure=0" >> etc/prop.default
	
	echo "persist.sys.sf.native_mode=1" >> etc/prop.default
	echo "persist.sys.sf.color_mode=1.0" >> etc/prop.default
	echo "persist.sys.sf.color_saturation=1.1" >> etc/prop.default

	# LMK - for Android Kernel that support it
	echo "ro.lmk.debug=true" >> etc/prop.default
	
	# Enable wireless display (Cast/Miracast)
	echo "persist.debug.wfd.enable=1" >> etc/prop.default
	
	# disable audio effect
	echo "persist.sys.phh.disable_audio_effects=1" >> etc/prop.default
	 	 

	# Add type and mapping for displayengine-hal-1.0
	echo "(typeattributeset hwservice_manager_type (displayengine_hwservice))" >> etc/selinux/plat_sepolicy.cil
	echo "(type displayengine_hwservice)" >> etc/selinux/plat_sepolicy.cil
	echo "(roletype object_r displayengine_hwservice)" >> etc/selinux/plat_sepolicy.cil
	echo "(typeattributeset displayengine_hwservice_26_0 (displayengine_hwservice))" >> etc/selinux/mapping/26.0.cil

	# Add allow  for displayengine-hal-1.0
	# echo "(allow hal_displayengine_default displayengine_hwservice (hwservice_manager (add find)))" >> /vendor/etc/selinux/nonplat_sepolicy.cil

	# Fix hwservice_manager
	echo "(allow system_server default_android_hwservice (hwservice_manager (find)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server default_android_service (service_manager (add)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server vendor_file (file (execute getattr map open read)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_app default_android_hwservice (hwservice_manager (find)))" >> etc/selinux/plat_sepolicy.cil

	# SELinux radio
	echo "(allow hal_audio_default hal_broadcastradio_hwservice (hwservice_manager (find)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow hal_audio_default audioserver (fifo_file (write)))" >> etc/selinux/plat_sepolicy.cil
		
	# SELinux to allow disk operation and camera
	echo "(allow fsck block_device (blk_file (open read write ioctl)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server sysfs (file (open read getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server system_data_root_file (dir (create add_name write)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server exported_camera_prop (file (open read getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server userspace_reboot_exported_prop (file (open read write getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow system_server userspace_reboot_config_prop (file (open read write getattr)))" >> etc/selinux/plat_sepolicy.cil	
	
	# Misc
	# avc: denied { ioctl } for path="pipe:[23197]" dev="pipefs" ino=23197 ioctlcmd=5413 scontext=u:r:hi110x_daemon:s0 tcontext=u:r:hi110x_daemon:s0 tclass=fifo_file permissive=0
	# echo "(allow hi110x_daemon self (fifo_file (ioctl read write getattr lock append open)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow bootanim userspace_reboot_exported_prop (file (open getattr read write)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vndservicemanager device (file (open getattr write read)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vndservicemanager device (chr_file (open write read getattr setattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow hw_ueventd kmsg_device (chr_file (open write read getattr setattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow logd device (file (open getattr read write)))" >> etc/selinux/plat_sepolicy.cil
	

	# Specific zygote
	echo "(allow zygote exported_camera_prop (file (open getattr read write)))" >> etc/selinux/plat_sepolicy.cil
		
	# Specific Honor 8x
	echo "(allow credstore self (capability (sys_resource)))" >> etc/selinux/plat_sepolicy.cil
		
	# PHH SU Daemon
	echo "(allow phhsu_daemon kernel (system (syslog_console)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon dmd_device (chr_file (open write read getattr setattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon self (capability (fsetid)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon splash2_data_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon teecd_data_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon modem_fw_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon modem_nv_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow phhsu_daemon modem_log_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	
	# resize2fs: avc: denied { ioctl } for path="/system" dev="mmcblk0p51" ino=2 ioctlcmd=6610 scontext=u:r:phhsu_daemon:s0 tcontext=u:object_r:rootfs:s0 tclass=dir permissive=1
	# echo "(allow phhsu_daemon rootfs (dir (ioctl create setattr search write read)))" >> etc/selinux/plat_sepolicy.cil
	
	
	# Add to enable file encryption (vold) - Fix permission on folder /data/unencrypted and /data/*/0
	echo "(allow vold block_device (blk_file (open read write)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vold dm_device (blk_file (ioctl)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vold system_data_root_file (file (create unlink read write)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vold_prepare_subdirs kernel (system (module_request)))" >> etc/selinux/plat_sepolicy.cil	
	echo "(allow vold_prepare_subdirs system_data_file (dir (create setattr search write read add_name)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vold_prepare_subdirs vold_prepare_subdirs (capability (fsetid)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow vold_prepare_subdirs system_data_root_file (dir (create setattr search write read add_name)))" >> etc/selinux/plat_sepolicy.cil
	

	# Fix init
	echo "(allow init device (chr_file (open write read getattr setattr)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow init splash2_data_file (filesystem (getattr)))" >> etc/selinux/plat_sepolicy.cil
	#not allow adb 
	#echo "(allow init rootfs (file (mounton)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow init system_file (dir (relabelfrom setattr write read)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow init system_file (file (relabelfrom)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow init sysfs_zram_uevent (file (relabelfrom)))" >> etc/selinux/plat_sepolicy.cil
	echo "(allow init cust_block_device (lnk_file (relabelto)))" >> etc/selinux/plat_sepolicy.cil
	

	# e2fsck
	echo "(allow fsck block_device (blk_file (open read write ioctl)))" >> etc/selinux/plat_sepolicy.cil
	
	# Cust
	echo "(allow cust rootfs (file (execute)))" >> etc/selinux/plat_sepolicy.cil

	
		
	# Force FUSE usage for emulated storage
	# ro.sys.sdcardfs=false
	# persist.fuse_sdcard=true
	# persist.esdfs_sdcard=false
	# persist.sys.sdcardfs=force_off

	# Force sdcardfs usage for emulated storage (Huawei)
	# Enabled sdcardfs, disabled esdfs_sdcard
	if grep -qs 'persist.sys.sdcardfs' etc/prop.default; then
		sed -i 's/^persist.sys.sdcardfs=force_off/persist.sys.sdcardfs=force_on/' etc/prop.default
	fi
	
	# Fallback device
	if grep -qs 'ro.sys.sdcardfs' etc/prop.default; then
		sed -i 's/^ro.sys.sdcardfs=false/ro.sys.sdcardfs=true/' etc/prop.default
		sed -i 's/^ro.sys.sdcardfs=0/ro.sys.sdcardfs=true/' etc/prop.default
	fi

	if grep -qs 'persist.esdfs_sdcard=true' etc/prop.default; then
		sed -i 's/^persist.esdfs_sdcard=false' etc/prop.default
	fi
	

	
	
)
sleep 1

umount d

e2fsck -f -y s-ab.img || true
resize2fs -M s-ab.img

