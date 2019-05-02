FROM debian:jessie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  imagemagick \
  libmagickwand-dev \
  libmagickcore-dev \
  libssl-dev \
  libxml2-dev \
  libmcrypt-dev \
  vim \
  gnupg2 \
  libcap2-bin \
  wget \
  curl \
  htop \
  zip \
  awscli \
  parallel \
  && rm -rf /var/lib/apt/lists/* && apt-get clean

WORKDIR /data
