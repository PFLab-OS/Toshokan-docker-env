FROM alpine:3.8 
RUN apk add --no-cache openssh-client
ADD https://github.com/eficode/wait-for/raw/master/wait-for /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for
COPY id_rsa /
#CMD /bin/bash -c "sftp -o ConnectTimeout=3 -o LogLevel=quiet -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -i /id_rsa -P ${SSH_PORT:-2222} ${SSH_USER:-hakase}@${SSH_ADDR:-localhost}"