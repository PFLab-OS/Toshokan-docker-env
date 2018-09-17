FROM livadk/toshokan_buildenv_base:efd8b3a03429f8e3f7e6f0e89c4d3b73a56b377d AS build-kernel
RUN make -j`nproc` bzImage

FROM alpine:3.8 AS build-rootfs
RUN apk add wget fakeroot
RUN wget https://nl.alpinelinux.org/alpine/v3.8/releases/x86_64/alpine-minirootfs-3.8.0-x86_64.tar.gz
RUN mkdir work
WORKDIR /work
RUN fakeroot && tar xf ../alpine-minirootfs-3.8.0-x86_64.tar.gz
RUN chmod 755 .
COPY inittab etc/inittab
COPY interfaces etc/network/interfaces
RUN apk add --no-cache --initdb --root . sudo dropbear openrc busybox-initscripts
RUN chroot . addgroup hakase
RUN chroot . adduser -S -s /bin/sh -G hakase hakase
RUN chroot . addgroup hakase wheel
RUN chroot . sh -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
RUN chroot . sh -c "echo 'hakase:hakase' | chpasswd"
RUN chroot . install -d /etc/runlevels/boot /etc/runlevels/default /etc/runlevels/sysinit /etc/runlevels/shutdown /etc/runlevels/nonetwork
RUN chroot . ln -s /etc/init.d/acpid /etc/runlevels/default
RUN chroot . ln -s /etc/init.d/bootmisc /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/crond /etc/runlevels/default
RUN chroot . ln -s /etc/init.d/devfs /etc/runlevels/sysinit
RUN chroot . ln -s /etc/init.d/dmesg /etc/runlevels/sysinit
RUN chroot . ln -s /etc/init.d/dropbear /etc/runlevels/default
RUN chroot . ln -s /etc/init.d/hostname /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/hwclock /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/hwdrivers /etc/runlevels/sysinit
RUN chroot . ln -s /etc/init.d/killprocs /etc/runlevels/shutdown
RUN chroot . ln -s /etc/init.d/loadkmap /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/mdev /etc/runlevels/sysinit
RUN chroot . ln -s /etc/init.d/modules /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/mount-ro /etc/runlevels/shutdown
RUN chroot . ln -s /etc/init.d/networking /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/savecache /etc/runlevels/shutdown
RUN chroot . ln -s /etc/init.d/swap /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/sysctl /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/syslog /etc/runlevels/boot
RUN chroot . ln -s /etc/init.d/urandom /etc/runlevels/boot
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> etc/sysctl.d/local.conf
RUN fakeroot && find | cpio --quiet -o -H newc | gzip -9 > ../rootfs
WORKDIR /

FROM ubuntu:16.04 AS build-qemu
RUN sed -i'~' -E "s@http://(..\.)?archive\.ubuntu\.com/ubuntu@http://pf.is.s.u-tokyo.ac.jp/~awamoto/apt-mirror/@g" /etc/apt/sources.list
RUN apt update
RUN apt install -y \
          libglib2.0-dev \
	  libfdt-dev \
	  libpixman-1-dev \
	  libncursesw5-dev \
	  zlib1g-dev \
	  flex \
	  bison \
	  wget \
	  build-essential
RUN wget https://download.qemu.org/qemu-2.12.0.tar.bz2
RUN tar xf qemu-2.12.0.tar.bz2
RUN mkdir build-qemu
WORKDIR build-qemu
RUN ../qemu-2.12.0/configure --enable-curses --target-list=x86_64-softmmu --static --prefix=/install
RUN make -j`nproc`
RUN make install

FROM alpine:3.8 AS qemu
MAINTAINER Shinichi Awamoto <sap.pcmail@gmail.com>
RUN apk add --no-cache xterm
COPY --from=build-qemu /install /
COPY --from=build-kernel /usr/src/linux/arch/x86/boot/bzImage .
COPY --from=build-rootfs /rootfs .

FROM qemu
ADD https://github.com/eficode/wait-for/raw/master/wait-for /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for
#RUN sh -c 'sh -c "qemu-system-x86_64 -smp 5 -m 4G -kernel bzImage -initrd rootfs -append \"root=/dev/ram rdinit=/sbin/init memmap=0x40000000\$0x40000000 console=ttyS0,115200\" -net nic -net user,hostfwd=tcp::2222-:22 -serial stdio -display none > /dev/null 2>&1 & "; wait-for localhost:2222 -- sleep 1'
CMD /bin/sh