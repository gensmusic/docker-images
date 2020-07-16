# docker-images

[building docker images](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action)


## faiss

- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04` 只包含开发依赖的环境,可以在此基础上编译 faiss
- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:rust-rs-0.8.0"` 基于 https://github.com/Enet4/faiss/archive/c_api_head.zip 和 `faiss/rust-rs.Dockerfile`
- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:test01` 基于 faiss的 5d1ed5b6fbb5f93806544a0f915a33946778783f 版本和 `faiss/Dockerfile`模板.