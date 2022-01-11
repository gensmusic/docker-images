FROM debian:buster-slim

RUN apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev

RUN apt install -y libunistring-dev

RUN mkdir -p ~/ffmpeg_sources ~/ffmpeg_build/bin

# 平时编译的时候就简单了.
ENV PATH "/root/ffmpeg_build/bin:$PATH"
ENV PKG_CONFIG_PATH "/root/ffmpeg_build/lib/pkgconfig"

# NASM
RUN cd ~/ffmpeg_sources && \
    wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
    tar xjvf nasm-2.15.05.tar.bz2 && \
    cd nasm-2.15.05 && \
    ./autogen.sh && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" && \
    make && \
    make install && \
    cd .. && rm -rf nasm-2.15.05*

# libx264
RUN cd ~/ffmpeg_sources && \
    git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
    cd x264 && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" --enable-static --enable-pic && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" make && \
    make install && \
    cd .. && rm -rf x264

# libx265
RUN apt-get -y install libnuma-dev && \
    cd ~/ffmpeg_sources && \
    wget -O x265.tar.bz2 https://bitbucket.org/multicoreware/x265_git/get/master.tar.bz2 && \
    tar xjvf x265.tar.bz2 && \
    rm -rf x265.tar.bz2 && \
    cd multicoreware*/build/linux && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" make && \
    make install && \
    cd ../../.. && rm -rf multicoreware*

# libvpx
RUN cd ~/ffmpeg_sources && \
    git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
    cd libvpx && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" make && \
    make install && \
    cd .. && rm -rf libvpx

# libfdk-aac
RUN cd ~/ffmpeg_sources && \
    git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
    make && \
    make install && \
    cd .. && rm -rf fdk-aac

# libopus
RUN cd ~/ffmpeg_sources && \
    git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
    cd opus && \
    ./autogen.sh && \
    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
    make && \
    make install && \
    cd .. && rm -rf opus

# libaom
RUN cd ~/ffmpeg_sources && \
    git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
    mkdir -p aom_build && \
    cd aom_build && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_TESTS=OFF -DENABLE_NASM=on ../aom && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" make && \
    make install && \
    cd .. && rm -rf aom*

# libsvtav1
RUN cd ~/ffmpeg_sources && \
    git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && \
    mkdir -p SVT-AV1/build && \
    cd SVT-AV1/build && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" make && \
    make install && \
    cd ../.. && rm -rf SVT-AV1

# libdav1d
RUN apt-get install -y python3-pip && \
    pip3 install --user meson
RUN cd ~/ffmpeg_sources && \
    git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git && \
    mkdir -p dav1d/build && \
    cd dav1d/build && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$HOME/ffmpeg_build" --libdir="$HOME/ffmpeg_build/lib" && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" ninja && \
    ninja install && \
    cd ../.. && rm -rf dav1d

# libvmaf
RUN cd ~/ffmpeg_sources && \
    wget https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz && \
    tar xvf v2.1.1.tar.gz && \
    rm -rf v2.1.1.tar.gz && \
    mkdir -p vmaf-2.1.1/libvmaf/build &&\
    cd vmaf-2.1.1/libvmaf/build && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. --prefix "$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" --libdir="$HOME/ffmpeg_build/lib" && \
    PATH="$HOME/ffmpeg_build/bin:$PATH" ninja && \
    ninja install && \
    cd ../../.. && rm -rf vmaf*
