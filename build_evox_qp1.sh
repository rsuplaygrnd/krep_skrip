# cleanup
rm -rf .repo/local_manifests/ prebuilts/clang/host/linux-x86
rm -rf device/qcom/sepolicy-legacy-um device/qcom/sepolicy_vndr/legacy-um
rm -rf device/asus/sdm660-common device/asus/X01BD

# init repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/rsuplaygrnd/evox_manifest.git -b bka-q1-los -g default,-mips,-darwin,-notdefault

# clone local manifests
git clone https://github.com/rsuplaygrnd/local_manifest --depth 1 -b X01BD-16.0_EvoX .repo/local_manifests

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

# Build the ROM
lunch lineage_X01BD-bp3a-userdebug
make installclean
m evolution

[ -d out ] && ls out/target/product/X01BD
