FROM --platform=linux/amd64 ubuntu:22.04
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

# Download and extract LessOS RK3566 toolchain
WORKDIR /opt
RUN wget https://github.com/lessui-hq/union-rk3566-toolchain/releases/download/lessos-toolchain-0.1/lessos-toolchain-RK3566.tar.gz && \
    tar xzf lessos-toolchain-RK3566.tar.gz && \
    mv build.LessOS-RK3566.aarch64/toolchain . && \
    rm -rf build.LessOS-RK3566.aarch64 lessos-toolchain-RK3566.tar.gz && \
    # Replace ccache wrapper scripts with direct symlinks to real binaries
    for f in /opt/toolchain/bin/aarch64-rocknix-linux-gnu-*; do \
        if [ -f "$f" ] && head -1 "$f" 2>/dev/null | grep -q '^#!/bin/sh'; then \
            real_bin=$(grep -o '/[^ ]*aarch64-rocknix-linux-gnu-[^ ]*' "$f" | tail -1 | sed 's|.*/toolchain|/opt/toolchain|'); \
            if [ -n "$real_bin" ] && [ -f "$real_bin" ]; then \
                rm "$f" && ln -s "$real_bin" "$f"; \
            fi; \
        fi; \
    done

# Setup workspace
RUN mkdir -p /root/workspace
VOLUME /root/workspace
WORKDIR /root/workspace

# Configure toolchain environment
ENV PATH="/opt/toolchain/bin:${PATH}"
ENV CROSS_COMPILE=/opt/toolchain/bin/aarch64-rocknix-linux-gnu-
ENV SYSROOT=/opt/toolchain/aarch64-rocknix-linux-gnu/sysroot
ENV PREFIX=/opt/toolchain/aarch64-rocknix-linux-gnu/sysroot/usr
ENV UNION_PLATFORM=rk3566

CMD ["/bin/bash"]