FROM debian:latest

ARG FIVEM_VER=19771-6dae1862ccfa4a2fcfd9999d74175d537d9052c6

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
