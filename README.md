# docker-images

[building docker images](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action)


## faiss

- `gensmusic/faiss-official:base` 是基于官方的镜像给出的,可以在此基础上编译 faiss
- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:dev` 只包含开发依赖的环境,可以在此基础上编译 faiss
- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:rust-rs-0.8.0"` 基于 https://github.com/Enet4/faiss/archive/c_api_head.zip 和 `faiss/rust-rs.Dockerfile`
- `gensmusic/faiss-10.2-cudnn7-devel-ubuntu18.04:test01` 基于 faiss的 5d1ed5b6fbb5f93806544a0f915a33946778783f 版本和 `faiss/Dockerfile`模板.


## ffmpeg

对应镜像 `gensmusic/ffmpeg`, 只是 tag 不同.

- `ffmpeg/debian.Dockerfile` 基于 `buster-slim` 的 ffmpeg 编译的, tag `debian-dev`,用于平日开发,可以编译,而且内置一个编译好的 ffmpeg.
- `ffmpeg/deps-debian.Dockerfile` 基于 `buster-slim`, 所有的依赖包括源代码都已经有了,只是没有进行编译, tag 为 `debian-deps`
- `ffmpeg/deps-ubuntu.Dockerfile` 同上,只是基于 `ubutnu`的, tag 为 `ubuntu-deps`
- `ffmpeg/runtime-deps-debian.Dockerfile` 基于 `buster-slim`, 是 ffmpeg runtime 的所有依赖安装, tag 为 `debian-runtime-deps`
- `ffmpeg/runtime-deps-slim-debian.Dockerfile` 基于 `buster-slim`, 是 ffmpeg runtime 的一定精简的版本,去掉了类似播放的依赖. tag为 `debian-runtime-deps-slim`
- `ffmpeg/runtime-deps-ubuntu.Dockerfile` 基于 ubuntu, 是 ffmpeg runtime 的所有依赖安装, tag为 `ubuntu-runtime-deps`

- `ffmpeg/ffmpeg-debian.Dockerfile` 是基于 `debian-dev` 和 `:debian-runtime-deps` 2 个镜像编译的出来的 ffmpeg, 没有源代码, 只有 ffmpeg 和 runtime 的依赖. tag 为 `ffmpeg-debian`