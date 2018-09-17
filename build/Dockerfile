FROM livadk/toshokan_buildenv_base:efd8b3a03429f8e3f7e6f0e89c4d3b73a56b377d AS build_header
RUN mkdir /workdir
RUN make headers_install INSTALL_HDR_PATH=/workdir

FROM alpine:3.8
RUN apk add --no-cache make g++
COPY --from=build_header /workdir /usr/src/linux-headers-4.14.34hakase
WORKDIR /