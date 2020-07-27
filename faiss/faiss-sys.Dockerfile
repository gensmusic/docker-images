FROM gensmusic/faiss-10.1-cudnn7-devel-ubuntu18.04:dev

ENV PATH="/root/.cargo/bin:$PATH"

RUN curl https://sh.rustup.rs -o rustup.sh && sh rustup.sh -y && cargo install bindgen