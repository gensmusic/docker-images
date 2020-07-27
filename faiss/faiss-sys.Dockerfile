FROM gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:dev

ENV PATH="${HOME}/.cargo/bin:$PATH"

RUN curl https://sh.rustup.rs -o rustup.sh && sh rustup.sh -y && cargo install bindgen