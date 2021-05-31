FROM debian:buster-slim
RUN apt-get update && \
    apt-get install -y gnat-8
WORKDIR /app
COPY . .
RUN mkdir obj
RUN gnat make -gnat2005 -D obj advgame.adb spritemaker.adb display.adb