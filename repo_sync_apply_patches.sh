#!/bin/bash
script=`realpath "$0"`
folder=`dirname "$script"`
root=`pwd`

bash "$folder"/clean_repo.sh
rm -f device/*/sepolicy/common/private/genfs_contexts

bash "$folder"/apply_patches.sh
