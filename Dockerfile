FROM debian:latest AS fivem

ARG FIVEM_VER=18940-637187b87e56d61092d06583927d3cd3501b8d49

WORKDIR /fivem
RUN mkdir -p /fivem/skipyrp && mkdir -p /fivem/txData/default && \
    apt-get update && apt-get install -y tini wget xz-utils && \
    wget -O- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_VER}/fx.tar.xz | tar xJ && \
    chmod +x /fivem/run.sh

RUN groupadd -g 2001 fivem && \
    useradd -u 2001 -g 2001 fivem --system --no-create-home && \
    chown -R fivem:fivem /fivem

EXPOSE 30120

USER fivem

CMD [""]
ENTRYPOINT ["/bin/sh", "/fivem/run.sh"]
