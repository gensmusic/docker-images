FROM gensmusic/faiss-capi-gpu-10.1-cudnn7-devel-ubuntu18.04:a93a4b39571db0ab6ad0b4ef42a6b8734ca05135


ENV PATH="/root/.cargo/bin:$PATH"

RUN wget https://sh.rustup.rs -O rustup.sh && \
    sh rustup.sh -y && cargo install bindgen

RUN mkdir -p /root/.cargo/ && \
    echo "[source.crates-io]" > /root/.cargo/config && \
    echo 'replace-with = "rustcc"' >> /root/.cargo/config && \
    echo '[source.rustcc]'  >> /root/.cargo/config && \
    echo 'registry = "git://crates.rustcc.cn/crates.io-index"' >> /root/.cargo/config