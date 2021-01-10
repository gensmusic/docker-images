FROM gensmusic/rust-bindgen:1.49

RUN rustup component add rustfmt

RUN apt-get update && apt-get install -y cmake openssl wget build-essential git

ARG MOSQUITTO_VERSION=2.0.4
ARG CJSON_VERSION=1.7.14
ARG LWS_VERSION=2.4.2

RUN wget https://github.com/warmcat/libwebsockets/archive/v${LWS_VERSION}.tar.gz -O /tmp/lws.tar.gz && \
    mkdir -p /build/lws && \
    tar --strip=1 -xf /tmp/lws.tar.gz -C /build/lws && \
    rm /tmp/lws.tar.gz && \
    cd /build/lws && \
    cmake . \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLWS_IPV6=ON \
        -DLWS_WITHOUT_BUILTIN_GETIFADDRS=ON \
        -DLWS_WITHOUT_CLIENT=ON \
        -DLWS_WITHOUT_EXTENSIONS=ON \
        -DLWS_WITHOUT_TESTAPPS=ON \
        -DLWS_WITH_SHARED=OFF \
        -DLWS_WITH_ZIP_FOPS=OFF \
        -DLWS_WITH_ZLIB=OFF && \
    make -j "$(nproc)" && \
    rm -rf /root/.cmake

RUN wget https://github.com/DaveGamble/cJSON/archive/v${CJSON_VERSION}.tar.gz -O /tmp/cjson.tar.gz && \
    mkdir -p /build/cjson && \
    tar --strip=1 -xf /tmp/cjson.tar.gz -C /build/cjson && \
    rm /tmp/cjson.tar.gz && \
    cd /build/cjson && \
    cmake . \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DBUILD_SHARED_AND_STATIC_LIBS=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DCJSON_BUILD_SHARED_LIBS=OFF \
        -DCJSON_OVERRIDE_BUILD_SHARED_LIBS=OFF \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j "$(nproc)" && \
    rm -rf /root/.cmake

RUN wget http://mosquitto.org/files/source/mosquitto-${MOSQUITTO_VERSION}.tar.gz -O /tmp/mosq.tar.gz && \
    mkdir -p /build/mosq && \
    tar --strip=1 -xf /tmp/mosq.tar.gz -C /build/mosq && \
    rm /tmp/mosq.tar.gz && \
    make -C /build/mosq -j "$(nproc)" \
        CFLAGS="-Wall -O2 -I/build/lws/include -I/build" \
        LDFLAGS="-L/build/lws/lib -L/build/cjson" \
        WITH_ADNS=no \
        WITH_DOCS=no \
        WITH_SHARED_LIBRARIES=yes \
        WITH_SRV=no \
        WITH_STRIP=yes \
        WITH_WEBSOCKETS=yes \
        prefix=/usr

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    install -d /usr/sbin/ && \
    install -s -m755 /build/mosq/client/mosquitto_pub /usr/bin/mosquitto_pub && \
    install -s -m755 /build/mosq/client/mosquitto_rr /usr/bin/mosquitto_rr && \
    install -s -m755 /build/mosq/client/mosquitto_sub /usr/bin/mosquitto_sub && \
    install -s -m644 /build/mosq/lib/libmosquitto.so.1 /usr/lib/libmosquitto.so.1 && \
    install -s -m755 /build/mosq/src/mosquitto /usr/sbin/mosquitto && \
    install -s -m755 /build/mosq/apps/mosquitto_ctrl/mosquitto_ctrl /usr/bin/mosquitto_ctrl && \
    install -s -m755 /build/mosq/apps/mosquitto_passwd/mosquitto_passwd /usr/bin/mosquitto_passwd && \
    install -s -m755 /build/mosq/plugins/dynamic-security/mosquitto_dynamic_security.so /usr/lib/mosquitto_dynamic_security.so && \
    install -m644 /build/mosq/mosquitto.conf /mosquitto/config/mosquitto.conf

RUN cp /usr/lib/libmosquitto.so.1 /usr/lib/libmosquitto.so