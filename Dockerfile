FROM debian:latest

ARG FIVEM_VER=30707-ab3ee4506333e02e4beb847c3db5467ae263ee6e

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
