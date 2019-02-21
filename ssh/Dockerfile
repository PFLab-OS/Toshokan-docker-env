FROM alpine:3.8 
RUN apk add --no-cache openssh-client rsync
ADD https://github.com/eficode/wait-for/raw/master/wait-for /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
COPY id_rsa /root/.ssh
COPY config /root/.ssh
RUN chmod 600 /root/.ssh/config
