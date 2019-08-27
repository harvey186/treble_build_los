#!/bin/bash
root=`pwd`
export USE_CCACHE=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G
source build/envsetup.sh
lunch treble_arm64_aeN-userdebug
make WITHOUT_CHECK_API=true installclean
make WITHOUT_CHECK_API=true systemimage
make WITHOUT_CHECK_API=true vndk-test-sepolicy
BUILD_DATE=`date +%Y%m%d`
mv $OUT/system.img $OUT/e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_aeN.img
cd $OUT
zip e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_aeN.img e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_aeN.img.zip
cd "$root"
cat $OUT/system/build.prop | grep security_patch
echo ""

bash copyturing.sh $OUT/e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_aeN.img.zip&


exit
lunch treble_arm64_beN-userdebug
make WITHOUT_CHECK_API=true installclean
make WITHOUT_CHECK_API=true systemimage
make WITHOUT_CHECK_API=true vndk-test-sepolicy
BUILD_DATE=`date +%Y%m%d`
mv $OUT/system.img $OUT/e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_beN.img
cd $OUT
zip e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_aeN.img e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm64_beN.img.zip
cd "$root"
cat $OUT/system/build.prop | grep security_patch
echo ""



lunch treble_arm_aeN-userdebug
make WITHOUT_CHECK_API=true installclean
make WITHOUT_CHECK_API=true systemimage
make WITHOUT_CHECK_API=true vndk-test-sepolicy
BUILD_DATE=`date +%Y%m%d`
mv $OUT/system.img $OUT/e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm_aeN.img
cd $OUT
zip e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm_aeN.img e-pie-$BUILD_DATE-UNOFFICIAL-treble_arm_aeN.img.zip
cd "$root"
cat $OUT/system/build.prop | grep security_patch
echo ""
