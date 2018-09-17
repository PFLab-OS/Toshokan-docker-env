FROM livadk/toshokan_buildenv_base:8706a5bf6e94126267acc5bc8e43d228ec4f268a AS build_header
RUN make -j`nproc` bindeb-pkg
RUN dpkg -i ../linux-headers-4.14.34hakase_4.14.34hakase-1_amd64.deb
RUN ls /usr/src/

FROM alpine:3.8
RUN apk add --no-cache make g++
COPY --from=build_header /workdir /usr/src/linux-headers-4.14.34hakase
WORKDIR /