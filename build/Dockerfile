FROM livadk/toshokan_buildenv_base:8706a5bf6e94126267acc5bc8e43d228ec4f268a AS build_header
RUN make -j`nproc` bindeb-pkg
RUN cd ..; mv linux-4.14.34 hoge
RUN dpkg -i ../linux-headers-4.14.34hakase_4.14.34hakase*.deb

FROM alpine:3.8
RUN apk add --no-cache make g++ libelf-dev
COPY --from=build_header /lib/modules/4.14.34hakase/build /lib/modules/4.14.34hakase/build
WORKDIR /