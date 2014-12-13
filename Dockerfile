FROM ubuntu:latest
ADD . /code
WORKDIR /code
RUN apt-get update && apt-get install -y bison flex build-essential curl python git cmake && curl -sL https://deb.nodesource.com/setup | bash - && apt-get install -y nodejs && npm install -g grunt-cli 
RUN curl https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz > emsdk-portable.tar.gz && tar xzf emsdk-portable.tar.gz && cd emsdk_portable && ./emsdk update && ./emsdk install latest && ./emsdk activate latest && source emsdk_env.sh && cd ../src && make emscripten
