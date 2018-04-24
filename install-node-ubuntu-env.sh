#!/bin/bash

LOCAL_SRC=/usr/local/src
NODE_VERSION=9.11.1

if [ -z "$(npm -v | grep 3.10.10)" -o -z "$(node -v | grep v6.9.5)" ] ; then
    cd $LOCAL_SRC
    git clone https://github.com/nodejs/node.git
    cd node
    git checkout -b v$NODE_VERSION tags/v$NODE_VERSION
    ./configure
    make install
fi
