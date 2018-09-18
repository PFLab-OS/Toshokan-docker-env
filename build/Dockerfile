FROM alpine:3.8
COPY --from=build_header /lib/modules/4.14.34hakase/build /lib/modules/4.14.34hakase/build
RUN apk add --no-cache make g++
WORKDIR /