FROM gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:dev

RUN curl https://sh.rustup.rs -o rustup.sh && sh rustup.sh -y && source $HOME/.cargo/env && cargo install bindgen