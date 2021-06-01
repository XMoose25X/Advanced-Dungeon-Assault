FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y gnat-10
WORKDIR /app
COPY . .
RUN gnatmake -f Source/advgame.adb Source/spritemaker.adb Source/test.adb Source/save_test.adb Source/inventory_test.adb Source/player_test.adb