FROM livadk/toshokan_qemu_kernel AS get-kernel
RUN mkdir /tmp/initramfs
WORKDIR /tmp/initramfs
RUN zcat /boot/initrd.img-4.13.0-45-generic | cpio -id

FROM alpine:3.8 AS build-rootfs
RUN apk add wget fakeroot
RUN wget https://nl.alpinelinux.org/alpine/v3.8/releases/x86_64/alpine-minirootfs-3.8.0-x86_64.tar.gz
RUN mkdir work
WORKDIR /work
RUN fakeroot && tar xf ../alpine-minirootfs-3.8.0-x86_64.tar.gz
RUN chmod 755 .
COPY inittab etc/inittab
COPY interfaces etc/network/interfaces
RUN apk add --no-cache --initdb --root . sudo bash openssh-server openssh-sftp-server openrc busybox-initscripts
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
RUN chroot . ln -s /etc/init.d/sshd /etc/runlevels/default
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
RUN chmod 700 home/hakase
RUN mkdir -m 700 home/hakase/.ssh
COPY id_rsa.pub home/hakase/.ssh/authorized_keys
RUN chroot . chown hakase:hakase /home/hakase/.ssh
RUN chroot . chown hakase:hakase /home/hakase/.ssh/authorized_keys
COPY --from=get-kernel /tmp/initramfs/lib/modules lib/modules
RUN fakeroot && find | cpio --quiet -o -H newc | gzip -9 > ../rootfs
WORKDIR /

FROM ubuntu:16.04 AS build-qemu
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
COPY --from=get-kernel /boot/vmlinuz-4.13.0-45-generic vmlinuz-4.13.0-45-generic
COPY --from=get-kernel /boot/initrd.img-4.13.0-45-generic initrd.img-4.13.0-45-generic
COPY --from=build-rootfs /rootfs .
CMD /bin/sh
