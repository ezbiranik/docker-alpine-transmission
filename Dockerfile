# AlpineLinux with transmission-daemon
FROM alpine:3.8

MAINTAINER Eugene Zbiranik <ezbiranik@gmail.com>

ENV LANG en_US.UTF-8

ENV TD_VERSION 2.94-r0

# transmission-daemon runs with UID=1000
RUN adduser -u 1000 -h /var/lib/transmission -s /sbin/nologin -H -D transmission

RUN apk --no-cache add transmission-daemon=${TD_VERSION} su-exec

COPY docker-entrypoint.sh /opt/

RUN chmod +x /opt/docker-entrypoint.sh

EXPOSE 9091 51413/tcp 51413/udp

ENTRYPOINT ["/opt/docker-entrypoint.sh"]

CMD ["transmission-daemon"]

