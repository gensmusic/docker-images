FROM debian:buster-slim

 
# 减少了
# libsdl2-dev libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev
RUN apt-get update -qq && apt-get -y install \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libtool \
  libvorbis-dev \
  zlib1g-dev \
  libnuma-dev && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*
