sudo apt -y install git build-essential gcc-aarch64-linux-gnu bc
cd ~
git clone https://github.com/raspberrypi/linux.git --depth 1 --branch rpi-4.14.y-rt
cd linux

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64

make bcmrpi3_defconfig
make -j$(nproc)

tar -czvf /vagrant/build.tgz arch/arm64/boot/