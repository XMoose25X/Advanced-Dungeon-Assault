FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y gnat-8
WORKDIR /app
COPY . .
RUN mkdir -p obj
RUN gnatmake -gnat95 -f advgame.adb spritemaker.adb