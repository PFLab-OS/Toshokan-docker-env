FROM alpine:3.8 
RUN apk add --no-cache bash openssh-client
COPY id_rsa /
#CMD /bin/bash -c "sftp -o ConnectTimeout=3 -o LogLevel=quiet -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -i /id_rsa -P ${SSH_PORT:-2222} ${SSH_USER:-hakase}@${SSH_ADDR:-localhost}"