FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y gnat-8
WORKDIR /app
COPY . .
WORKDIR /app/Source
RUN gnatmake -gnat95 -f advgame.adb spritemaker.adb
RUN cp advgame ..
WORKDIR /app