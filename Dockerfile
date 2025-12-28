FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update && apt -y install \
	autoconf \
	bc \
    build-essential \
    bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	locales \
	make \
	rsync \
	scons \
	tree \
	unzip \
	wget \
  && rm -rf /var/lib/apt/lists/*

# Download and extract RGB30 toolchain (same hardware as RK3566)
WORKDIR /work
RUN mkdir -p MOSS/build.MOSS-RK3566.aarch64 && \
    cd MOSS/build.MOSS-RK3566.aarch64 && \
    wget https://github.com/shauninman/union-rgb30-toolchain/releases/download/v001/rgb30-toolchain-aarch64.tar.xz && \
    tar xf rgb30-toolchain-aarch64.tar.xz && \
    rm rgb30-toolchain-aarch64.tar.xz

# Setup workspace
RUN mkdir -p /root/workspace
VOLUME /root/workspace
WORKDIR /root/workspace

# Configure toolchain environment
ENV PATH="/work/MOSS/build.MOSS-RK3566.aarch64/toolchain/usr/bin:${PATH}:/work/MOSS/build.MOSS-RK3566.aarch64/toolchain/aarch64-libreelec-linux-gnueabi/sysroot/bin"
ENV CROSS_COMPILE=/work/MOSS/build.MOSS-RK3566.aarch64/toolchain/bin/aarch64-libreelec-linux-gnueabi-
ENV PREFIX=/work/MOSS/build.MOSS-RK3566.aarch64/toolchain/aarch64-libreelec-linux-gnueabi/sysroot/usr
ENV UNION_PLATFORM=rk3566

CMD ["/bin/bash"]