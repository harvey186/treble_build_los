#!/bin/bash
echo ""
echo "eOS Q GSI Buildbot"

START=`date +%s`
BUILD_DATE="$(date +%Y%m%d)"
BL=$PWD/treble_build_los

echo
#### repo sync
read -p "apply y/n? " PATCH
echo '____________________'
echo

if [[ $PATCH = 'y' ]]; then
################# PATCH START ################
cd vendor/lineage
sed -i '/LibreOfficeViewer*/d' config/common.mk
cd ../../
echo "Setting up build environment"
export USE_CCACHE=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G
source build/envsetup.sh &> /dev/null
echo ""

echo "Applying PHH patches"
cd frameworks/base
git revert e0a5469cf5a2345fae7e81d16d717d285acd3a6e --no-edit # FODCircleView: defer removal to next re-layout
git revert 817541a8353014e40fa07a1ee27d9d2f35ea2c16 --no-edit # Initial support for in-display fingerprint sensors
cd ../..
rm -f device/*/sepolicy/common/private/genfs_contexts
cd device/phh/treble
git clean -fdx
bash generate.sh lineage
cd ../../..
bash treble_experimentations/apply-patches.sh treble_patches
echo ""

echo "Applying universal patches"
cd frameworks/base
git am $BL/patches/0001-Disable-vendor-mismatch-warning.patch
git am $BL/patches/0001-Keyguard-Show-shortcuts-by-default.patch
#git am $BL/patches/0001-core-Add-support-for-MicroG.patch
cd ../..
cd lineage-sdk
git am $BL/patches/0001-sdk-Invert-per-app-stretch-to-fullscreen.patch
cd ..
cd packages/apps/LineageParts
git am $BL/patches/0001-LineageParts-Invert-per-app-stretch-to-fullscreen.patch
cd ../../..
cd vendor/lineage
git am $BL/patches/0001-vendor_lineage-Log-privapp-permissions-whitelist-vio.patch
cd ../..
echo ""

echo "Applying GSI-specific patches"
cd build/make
git am $BL/patches/0001-Revert-Enable-dyanmic-image-size-xfor-GSI.patch
cd ../..
cd device/phh/treble
#git revert 82b15278bad816632dcaeaed623b569978e9840d --no-edit # Update lineage.mk for LineageOS 16.0
#git am $BL/patches/0001-Remove-fsck-SELinux-labels.patch
#git am $BL/patches/0001-treble-Add-overlay-lineage.patch
#git am $BL/patches/0001-treble-Don-t-specify-config_wallpaperCropperPackage.patch
#git am $BL/patches/0001-Increase-system-partition-size-for-arm_ab.patch
cd ../../..
cd external/tinycompress
git revert fbe2bd5c3d670234c3c92f875986acc148e6d792 --no-edit # tinycompress: Use generated kernel headers
cd ../..
cd vendor/lineage
git am $BL/patches/0001-build_soong-Disable-generated_kernel_headers.patch
cd ../..
######## encryption disable  #############
#
rm vendor/qcom/opensource/cryptfs_hw
#
##############################
git revert 6a3fc11bcc95d1abebb60e5d714adf75ece83102 --no-edit # cryptfs_hw: Use generated kernel headers
git am $BL/patches/0001-Header-hack-to-compile-xFor-8974.patch
cd ../../../..
echo ""

echo "CHECK PATCH STATUS NOW!"
sleep 5
echo ""


fi
####################  PATCH ENDE ############

echo "Setting up build environment"
source build/envsetup.sh
export USE_CCACHE=1
export CCACHE_SIZE=100G

export WITHOUT_CHECK_API=true
export WITH_SU=false
mkdir -p ~/build-output/

buildVariant() {
	lunch ${1}-userdebug
#	make installclean
	make -j8 systemimage
#	make vndk-test-sepolicy
	cp $OUT/system.img ~/build-output/LeOS_Q-$BUILD_DATE-JoJo-${1}.img
}

#buildVariant treble_arm_avN
#buildVariant treble_a64_avN
#buildVariant treble_a64_bvN
#buildVariant treble_arm64_avN
#buildVariant treble_a64_aeN
buildVariant treble_arm64_bvN
ls ~/build-output | grep 'LeOS'

END=`date +%s`
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))
echo "Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo ""
