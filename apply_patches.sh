#!/bin/bash
script=`realpath "$0"`
folder=`dirname "$script"`
root=`pwd`

bash "$folder"/apply_phh_patches.sh treble_patches

cd "$root"/device/phh/treble
bash generate.sh lineage
echo "Applying universal patches"
cd "$root"/frameworks/base
git am "$folder"/0001-Disable-vendor-mismatch-warning.patch
git am "$folder"/0001-Keyguard-Show-shortcuts-by-default.patch
git am "$folder"/0001-core-Add-support-for-MicroG.patch
cd "$root"/lineage-sdk
git am "$folder"/0001-sdk-Invert-per-app-stretch-to-fullscreen.patch
cd "$root"/packages/apps/LineageParts
git am "$folder"/0001-LineageParts-Invert-per-app-stretch-to-fullscreen.patch
echo ""
echo "Applying GSI-specific patches"
cd "$root"/build/make
git am "$folder"/0001-Revert-Enable-dyanmic-image-size-for-GSI.patch
cd "$root"/device/phh/treble
#git revert 82b15278bad816632dcaeaed623b569978e9840d --no-edit #Update lineage.mk for LineageOS 16.0
#git revert df25576594f684ed35610b7cc1db2b72bc1fc4d6 --no-edit #exfat fsck/mkfs selinux label
#git am "$folder"/0001-treble-Add-overlay-lineage.patch
cd "$root"/external/tinycompress
git revert fbe2bd5c3d670234c3c92f875986acc148e6d792 --no-edit #tinycompress: Use generated kernel headers
cd "$root"/vendor/lineage
git am "$folder"/0001-build_soong-Disable-generated_kernel_headers.patch
cd "$root"/vendor/qcom/opensource/cryptfs_hw
git revert 6a3fc11bcc95d1abebb60e5d714adf75ece83102 --no-edit #cryptfs_hw: Use generated kernel headers
git am "$folder"/0001-Header-hack-to-compile-for-8974.patch
cd "$root"
echo ""
