# RK3566 Toolchain Docker Image

Cross-compilation toolchain for Rockchip RK3566 devices (RGB30, RG353P, etc.) running LessOS.

## Overview

This Docker image provides a pre-built toolchain for building LessUI on RK3566-based devices. The toolchain is sourced from the RGB30 toolchain (same SoC) and baked directly into the Docker image.

## Usage

The image is automatically built and published by GitHub Actions to `ghcr.io/lessui-hq/union-rk3566-toolchain:latest`.

From the LessUI repository:
```bash
make build PLATFORM=RK3566
```

## Local Development

```bash
make shell  # Enters the toolchain container
```

The container's `/root/workspace` is bound to `./workspace` by default. The toolchain is located at `/work/MOSS/build.MOSS-RK3566.aarch64` inside the container.

## Toolchain Source

Uses the RGB30 toolchain from https://github.com/shauninman/union-rgb30-toolchain (RK3566 hardware is identical to RGB30).
