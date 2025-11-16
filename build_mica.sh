# cleanup
rm -rf .repo/local_manifests/ prebuilts/clang/host/linux-x86/
[ -d vendor/gms ] && rm -rf vendor/gms/
[ -d device/lineage/sepolicy ] && rm -rf device/lineage/sepolicy/
[ -d device/asus/X01BD ] && rm -rf device/asus/X01BD/

# init repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/rsuntk/mica_manifest.git -b 16-qpr1 -g default,-mips,-darwin,-notdefault

# clone local manifests
git clone https://github.com/rsuplaygrnd/local_manifest --depth 1 -b bp3 .repo/local_manifests

# repo sync
[ -f /usr/bin/resync ] && /usr/bin/resync || /opt/crave/resync.sh

# setup KernelSU
if [ -d kernel/asus/sdm660 ]; then
	cd kernel/asus/sdm660
	curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s main
	cd ../../..
fi

# Set up build environment
export BUILD_USERNAME=rsuntk
export BUILD_HOSTNAME=nobody
export TZ="Asia/Jakarta"
source build/envsetup.sh

export TARGET_EXCLUDE_GMS=true

# Build the ROM
lunch mica_X01BD-bp3a-userdebug
# cleanup #3
#make installclean
m mica-release

[ -d out ] && ls out/target/product/X01BD
