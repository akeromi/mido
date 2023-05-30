#!/bin/bash

set -e
set -x

# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/PixelExperience/manifest.git -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/IdkAnythin07/local_manifest.git --depth 1 -b Pixel_exp .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
aosp_tissot-userdebug
m aex -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/mido/*.zip
