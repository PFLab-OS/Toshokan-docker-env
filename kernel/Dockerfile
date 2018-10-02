FROM ubuntu:16.04 AS build-kernel
RUN apt update
RUN apt install -y wget build-essential
RUN apt install -y libssl-dev fakeroot bison flex
RUN apt install -y kernel-package
RUN apt install -y python3
#bc kmod cpio cpio libncurses5-dev
WORKDIR /usr/src/
RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.34.tar.xz
RUN tar xf linux-4.14.34.tar.xz
RUN ln -s linux-4.14.34 linux
COPY hakase.patch .
WORKDIR linux
RUN make x86_64_defconfig
RUN patch -p1 < ../hakase.patch
RUN wget https://raw.githubusercontent.com/nichoski/kergen/master/kergen/depgen
# for docker
RUN yes | python3 ./depgen CONFIG_CGROUP_DEVICE CONFIG_MEMCG CONFIG_VETH CONFIG_BRIDGE CONFIG_BRIDGE_NETFILTER CONFIG_NETFILTER_XT_MATCH_IPVS CONFIG_DEVPTS_MULTIPLE_INSTANCES CONFIG_OVERLAY_FS
RUN yes | python3 ./depgen CONFIG_USB_XHCI_PCI
RUN yes "" | make oldconfig
RUN sed -i 's/=m$/=y$/g' .config
RUN apt install -y libelf-dev
RUN make -j`nproc` bzImage
RUN make -j`nproc` bindeb-pkg
RUN dpkg -i ../linux-*-4.14.34hakase_4.14.34hakase*.deb
