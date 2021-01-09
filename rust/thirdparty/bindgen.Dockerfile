ARG RUST_VERSION=1.49

FROM rust:${RUST_VERSION}

RUN apt-get update && \
    apt-get install -y wget git llvm-dev libclang-dev clang && \
    apt-get clean

RUN cargo install bindgen