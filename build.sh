# cleanup
rm -rf .repo/local_manifests/ prebuilts/clang/host/linux-x86

# init repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/rsuplaygrnd/rising_manifests.git -b sixteen -g default,-mips,-darwin,-notdefault

# clone local manifests
git clone https://github.com/rsuplaygrnd/local_manifest --depth 1 -b X01BD-16.0_RisingOS .repo/local_manifests

# repo sync
[ -f /usr/bin/resync ] && /usr/bin/resync || /opt/crave/resync.sh

# cleanup #2
[ -d out ] && rm -rf out/target || echo "[-] No need to clean out/"

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
riseup X01BD userdebug
# cleanup #3
make installclean
rise b

[ -d out ] && ls out/target/product/X01BD
