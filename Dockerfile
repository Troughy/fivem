FROM debian:latest

ARG FIVEM_VER=27938-e8c8b5085d761881e99f2723c1a56ae9838e97f2

WORKDIR /fivem

RUN apt-get update && apt-get install -y wget xz-utils && \
    wget -O- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz | tar xJ && \
    chmod +x /fivem/run.sh && \
    groupadd -g 2001 fivem && \
    useradd -u 2001 -g 2001 fivem --system --no-create-home && \
    chown -R fivem:fivem /fivem

EXPOSE 30120

USER fivem

CMD [""]
ENTRYPOINT ["/bin/sh", "/fivem/run.sh"]
