#!/bin/bash

go get -v -u github.com/nsf/gocode
go get -v -u github.com/rogpeppe/godef
go get -v -u github.com/bradfitz/goimports
go get -v -u github.com/kardianos/govendor

if [ xDarwin == x$(uname) ]; then
   echo 'export GOROOT=/usr/local/Cellar/go/1.9/libexec' >> ~/.profile
   echo "export GOPATH=/Users/$(whoami)/git/go" >> ~/.profile
   echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.profile
fi

if [ xLinux == x$(uname) ]; then
   echo 'export GOROOT=/usr/local/src/go' >> ~/.profile
   echo "export GOPATH=~/git/go" >> ~/.profile
   echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.profile
fi
