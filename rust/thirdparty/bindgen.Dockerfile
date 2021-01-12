ARG RUST_VERSION=1.49

FROM rust:${RUST_VERSION}

RUN apt-get update && \
    apt-get install -y wget git llvm-dev libclang-dev clang && \
    apt-get clean

ARG CARGO_CONFIG="/usr/local/cargo/config"
RUN mkdir -p "/usr/local/cargo" && \
    echo "[source.crates-io]" >> ${CARGO_CONFIG} && \
    echo 'replace-with = "rustcc"' >> ${CARGO_CONFIG} && \
    echo '[source.rustcc]' >> ${CARGO_CONFIG} && \
    echo 'registry = "git://crates.rustcc.cn/crates.io-index"' >> ${CARGO_CONFIG} && \
    cat ${CARGO_CONFIG}

RUN cargo install bindgen
ENV PATH="/root/.cargo/bin:/usr/local/cargo/bin:$PATH"