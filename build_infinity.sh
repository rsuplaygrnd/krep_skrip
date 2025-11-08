# cleanup
rm -rf .repo/local_manifests/ prebuilts/clang/host/linux-x86

# init repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/rsuplaygrnd/infinity_manifest.git -b 16 -g default,-mips,-darwin,-notdefault

# clone local manifests
git clone https://github.com/rsuplaygrnd/local_manifest.git --depth 1 -b X01BD-16.0_Infinity_X .repo/local_manifests

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
lunch infinity_X01BD-user
# cleanup #3
#make installclean
m bacon

[ -d out ] && ls out/target/product/X01BD
