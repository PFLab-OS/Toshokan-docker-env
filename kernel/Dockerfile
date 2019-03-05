FROM ubuntu:16.04

RUN echo 'Acquire::HTTP::Proxy "http://133.11.12.17:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends
RUN sed -i.bak  -s 's%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g'  /etc/apt/sources.list
RUN sed -i.bak  -s 's%http://security.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g'  /etc/apt/sources.list

RUN apt update
RUN apt install -y initramfs-tools linux-image-4.13.0-45-generic linux-headers-4.13.0-45-generic build-essential kernel-package
