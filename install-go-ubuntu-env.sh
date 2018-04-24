#!/bin/bash

CUSER=$(who am i | cut -d' ' -f1)
CGROUP=$(groups $CUSER | cut -d' ' -f1)
LOCAL_SRC=/usr/local/src
GOROOT=$LOCAL_SRC/go
GOPATH=~/git/gopro
GOVERSION=1.10

##############################################
# Check if run as root
##############################################
if [ xroot != x$(whoami) ]
then
    echo "You must run as root (Hint: Try prefix 'sudo' while execution the script)"
    exit
fi

##############################################
# Set GOPATH, GOROOT, and install go
##############################################
if [ ! $(which go) ] && [ ! -x $LOCAL_SRC/go/bin/go ] ; then
    echo "Install go"
    cd $LOCAL_SRC
    git clone https://github.com/golang/go.git
    cd go
    git checkout release-branch.go1.4
    cp -r $LOCAL_SRC/go ~/
    cd ~ && mv go go1.4
    cd go1.4/src
    ./all.bash
    if [ ! -x ~/go1.4/bin/go ] ; then
	echo "error: NO excutable go program"
	rm -rf ~/go1.4
	exit
    fi
    cd $LOCAL_SRC/go
    git checkout release-branch.go$GOVERSION
    cd src
    ./all.bash
    if [ ! -x $LOCAL_SRC/go/bin/go ] ; then
	echo "error: NO excutable go program"
	rm -rf ~/go1.4
	exit
    fi
    rm -rf ~/go1.4
fi

if [ ! -n "$(env | grep GOPATH)" ] ; then
    echo "export GOPATH=$GOPATH" >> ~/.profile

fi
if [ ! -n "$(env | grep GOROOT)" ] ; then
    echo "export GOROOT=$GOROOT" >> ~/.profile
    echo 'PATH="$GOROOT/bin:$PATH"' >> ~/.profile
fi
