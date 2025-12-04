# aurum-linux

This is a Linux sandbox for an Aurum system **and currently WIP (Work In Progress)**.

Currently the sandbox only showcases the GLSL glass effect that will be used in the Bismuth subsystem. To change the wallpaper, replace `wallpaper.png` with your desired image. JPG images are also supported, but the `wallpaper.png` file will be prioritized over `wallpaper.jpg`.

Documentation about Aurum will be coming to Github soon at <https://github.com/37o1/aurum-documentation>.

## Showcase

Here is a screenshot of what the glass demo should look like:

![alt text](screenshots/image.png)

## Requirements

> **This section may be incomplete, inaccurate or just bad. You can help me improve it by testing the performance on your machine and/or checking any requirements I missed and sending the results along with your system information to [my Telegram](https://t.me/artificialsentience).**

### System Requirements

* Linux kernel 3.2+
* glibc 2.34^
* OpenGL 4.6 core profile support
* GPU architectures:
  * Intel Gen9+ (Skylake or newer)
  * AMD GCN 2nd generation or newer
  * NVIDIA Kepler or newer
* Mesa or vendor driver exposing GL 4.6
* At least 200MiB of usable memory<sup>*2</sup>
* At least 2MiB of free disk space<sup>*2</sup>

<sup>*1</sup> Guaranteed only for the lastest release.
<sup>*2</sup> Guesstimated, but over the meaasured minimum and should cover roughly any build of the last released version.

### Build Requirements

To build this project from source, the following components must be present on the system:

* D compiler:
  * `dmd` (used during development)
  * `ldc` is also supported and tested
* **Dub** (D package manager and build orchestrator)
* OpenGL development headers with support for GLSL 460. Typically provided by:
  * `mesa` / `mesa-devel`
  * `libglvnd` / `libglvnd-devel`
* Raylib development libraries, including:
  * `libraylib.so`
  * `raylib` headers
* GLSL compiler:
  * `glslang` or `glslang-tools`
* These are required for linking raylib and OpenGL:
  * `pkg-config`
  * Development C toolchain:
    * `gcc` or `clang`
    * make (if building raylib from source)
* Runtime dependencies **(non-exhaustive)**:
  * Binary links to the following shared objects at runtime:
    * `linux-vdso.so.1` (implicit)
    * `libm.so.6`
    * `libgcc_s.so.1`
    * `libc.so.6` (>= 2.34 required)
    * `/lib64/ld-linux-x86-64.so.2`
  * Raylib may also pull:
    * `libdl.so.2`
    * `libGL.so.1`
    * `libpthread.so.0`
    * `libX11.so.6`

## Sources

Default wallpaper source: <https://www.pexels.com/photo/close-up-shot-of-irregular-crystal-prisms-12602048/>

---

<p align="center">Copyright © 2025 37o1</p>
