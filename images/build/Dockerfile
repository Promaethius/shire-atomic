FROM fedora:29

VOLUME /srv /manifests

COPY ./build.sh /build.sh

RUN dnf update -y -q && \
    dnf install -y -q git rpm-ostree createrepo && \
    mkdir -p /srv/repo && \
    chmod +x /build.sh

CMD /build.sh
