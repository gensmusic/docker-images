FROM gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:dev

RUN  curl https://sh.rustup.rs -sSf | sh && \
    cargo install bindgen