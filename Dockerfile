FROM rust:latest

# Detailed errors
ENV RUST_BACKTRACE=1

# Install dependencies
RUN dpkg --add-architecture armhf
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libc6-dev:armhf \
    qemu-user-static

# Install ARMv7 compiler
RUN wget https://github.com/richfelker/musl-cross-make/archive/master.tar.gz
RUN tar xzf master.tar.gz
WORKDIR /musl-cross-make-master
RUN cat config.mak.dist
ADD config.mak ./
RUN make
RUN make install

RUN arm-linux-musleabihf-gcc --version

# Add Rust compilation target
RUN rustup target add armv7-unknown-linux-musleabihf