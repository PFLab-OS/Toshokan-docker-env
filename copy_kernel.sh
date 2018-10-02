#!/bin/sh
docker run -d --rm -it --name toshokan_kernel_tmp livadk/toshokan_kernel_build sh
docker cp toshokan_kernel_tmp:/usr/src/linux-headers-4.14.34hakase_4.14.34hakase-2_amd64.deb .
docker cp toshokan_kernel_tmp:/usr/src/linux-libc-dev_4.14.34hakase-2_amd64.deb .
docker cp toshokan_kernel_tmp:/usr/src/linux-image-4.14.34hakase_4.14.34hakase-2_amd64.deb .
docker rm -f toshokan_kernel_tmp
