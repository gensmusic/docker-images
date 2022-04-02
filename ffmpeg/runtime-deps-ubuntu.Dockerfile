FROM debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get -y install \
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
  zlib1g-dev \
  libnuma-dev && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*
