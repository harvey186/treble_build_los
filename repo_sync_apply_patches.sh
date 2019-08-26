#!/bin/bash
script=`realpath "$0"`
folder=`dirname "$script"`
root=`pwd`

bash "$folder"/clean_repo.sh
rm -f device/*/sepolicy/common/private/genfs_contexts
cd device/phh/treble
git clean -fdx
bash generate.sh lineage
cd ../../..
bash "$folder"/apply_patches.sh
