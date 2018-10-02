FROM ubuntu:16.04 AS build-kernel
RUN apt update
RUN apt install -y wget build-essential
RUN apt install -y libssl-dev fakeroot bison flex
RUN apt install -y kernel-package
RUN apt install -y python3
RUN apt install -y libelf-dev
#bc kmod cpio cpio libncurses5-dev
WORKDIR /usr/src/
RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.34.tar.xz
RUN tar xf linux-4.14.34.tar.xz
RUN ln -s linux-4.14.34 linux
COPY hakase.patch .
WORKDIR linux
RUN wget -qO- http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux-headers-4.15.0-20-generic_4.15.0-20.21_amd64.deb | dpkg-deb --fsys-tarfile /dev/stdin | tar Ox --wildcards './usr/src/*/.config' > .config
RUN patch --verbose -p1 < ../hakase.patch
RUN wget https://raw.githubusercontent.com/nichoski/kergen/master/kergen/depgen
# for docker
# RUN yes | python3 ./depgen CONFIG_CGROUP_DEVICE CONFIG_MEMCG CONFIG_VETH CONFIG_BRIDGE CONFIG_BRIDGE_NETFILTER CONFIG_NETFILTER_XT_MATCH_IPVS CONFIG_DEVPTS_MULTIPLE_INSTANCES CONFIG_OVERLAY_FS
RUN yes "" | make oldconfig
RUN make -j`nproc` bzImage
RUN make -j`nproc` bindeb-pkg
RUN dpkg -i ../linux-*-4.14.34hakase_4.14.34hakase*.deb
