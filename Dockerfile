ARG ARCH=

FROM ${ARCH}alpine:latest as builder

LABEL maintainer="fatred@gmail.com"

RUN apk update && apk add make gcc git libc-dev

WORKDIR /tmp
RUN git clone https://github.com/pcherenkov/udpxy.git \
    && cd udpxy/chipmunk \
    && make && make install

FROM ${ARCH}alpine:latest

COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/udpxy
COPY --from=builder /usr/local/bin/udpxrec /usr/local/bin/udpxrec

EXPOSE 4022/tcp

ENV MCAST_UPSTREAM_INT="eth0"
ENTRYPOINT ["/usr/local/bin/udpxy"]
CMD ["-v", "-T", "-S", "-p", "4022", "-m", "${MCAST_UPSTREAM_INT}"]

#ENTRYPOINT ["/usr/local/bin/udpxy"]
#CMD ["-v", "-T", "-p", "4022"]
