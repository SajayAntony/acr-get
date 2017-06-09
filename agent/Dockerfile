FROM alpine:latest
COPY ./device-setup.sh /device-setup.sh 
RUN apk add --update \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community docker \
    && rm -rf /var/cache/apk
CMD ["/bin/sh", "/device-setup.sh"] 


