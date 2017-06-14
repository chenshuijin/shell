#!/bin/bash

CUSER=$(who am i | cut -d' ' -f1)
CGROUP=$(groups $CUSER | cut -d' ' -f1)
LOCAL_SRC=/usr/local/src
GOROOT=$LOCAL_SRC/go
GOPATH=/data/git
DOCKER_STORGE_PATH=/data/docker
FABRIC_PATH=$GOPATH/src/github.com/hyperledger

#################################################
# The git hash of fabric and fabric-ca, important
#################################################
FABRIC_GIT_HASH=$1
FABRIC_CA_GIT_HASH=$2

##############################################
# Check if run as root
##############################################
if [ xroot != x$(whoami) ]
then
    echo "You must run as root (Hint: Try prefix 'sudo' while execution the script)"
    exit
fi

export PATH=$GOROOT/bin:$PATH
export GOROOT=$GOROOT
export GOPATH=$GOPATH

##############################################
# Install git
##############################################
if [ ! $(which git) ] ; then
    echo "Install git"
    apt-get install -y git
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
    git checkout release-branch.go1.7
    cd src
    ./all.bash
    if [ ! -x $LOCAL_SRC/go/bin/go ] ; then
	echo "error: NO excutable go program"
	rm -rf ~/go1.4
	exit
    fi
    rm -rf ~/go1.4
fi

if [ ! -n $(env | grep GOPATH) ] ; then
    export GOPATH=$GOPATH
    mkdir -p $GOPATH
    chown -hR $CUSER $GOPATH
    chgrp -hR $CGROUP $GOPATH
fi

if [ ! -n $(env | grep GOROOT) ] ; then
    export GOROOT=$GOROOT
fi

##############################################
# mkdir fabric_path
##############################################
if [ ! -d $FABRIC_PATH ] ; then
    mkdir -p $FABRIC_PATH
    chown -hR $CUSER $FABRIC_PATH
    chgrp -hR $CGROUP $FABRIC_PATH
fi

##############################################
# Check docker image path, if not exist mkdir
##############################################
if [ ! -d $DOCKER_STORGE_PATH ] ; then
    mkdir $DOCKER_STORGE_PATH
#    chown -hR $CUSER $DOCKER_STORGE_PATH
#    chgrp -hR $CGROUP $DOCKER_STORGE_PATH
fi

##############################################
# Install docker
##############################################
if [ ! -x "$(which docker)" ] ; then
    curl -fsSL https://get.docker.com/ | sh
    usermod -aG docker $CUSER
fi
##############################################
# Start docker service
##############################################
if [ ! "$(service docker status | grep start/running)" ]; then
    service docker start
fi
###############################################
# Change docker graph to /data/docker
###############################################
if [ ! -n "$(cat /etc/default/docker | grep 'data/docker')" ] ; then
    echo 'change docker graph to /data/docker'
    echo DOCKER_OPTS=\"-g /data/docker\" | cat >> /etc/default/docker
    chmod 666 /var/run/docker.sock
fi

###############################################
# Check make, gcc, python, pip .eg..
###############################################
if [ ! $(which make) ] ; then
    echo "Install make"
    apt-get install -y make
fi

if [ ! $(which gcc) ] ; then
    echo "Install gcc"
    apt-get install -y gcc
fi

if [ -z "$(dpkg -l | grep python-dev)" ] ; then
    apt-get install -y python-dev python
fi

if [ ! $(which pip) ] ; then
    apt-get install -y make python-pip
    pip install --upgrade pip
    pip install behave nose docker-compose protobuf grpc grpcio
    pip install cryptography ecdsa slugify
    pip install -I couchdb==1.0 \
	pyOpenSSL==16.2.0 sha3==0.2.1
fi

if [ ! $(which nodejs) ] ; then
    apt-get install -y nodejs-dev
fi

if [ ! $(which npm) ] ; then
    apt-get install -y npm
fi

if [ -z "$(whereis libsnappy.so | grep libsnappy.so)" ] ; then
    echo 'install libsnappy-dev'
    apt-get install -y libsnappy-dev
fi

if [ -z "$(dpkg -l libltdl-dev | grep libltdl-dev)" ] ; then
    echo 'install libltdl-dev'
    apt-get install -y libltdl-dev
fi

if [ -z "$(whereis libbz2.so | grep libbz2.so)" ] ; then
    apt-get install -y libbz2-dev
fi

if [ -z "$(dpkg -l | grep libgflags-dev)" ] ; then
    apt-get install -y libgflags-dev
fi

if [ ! -d $FABRIC_PATH/fabric ] ; then
    cd $FABRIC_PATH
    git clone https://github.com/hyperledger/fabric.git
    chown -hR $CUSER $FABRIC_PATH
    chgrp -hR $CGROUP $FABRIC_PATH
fi

cd $FABRIC_PATH/fabric
git checkout master
git pull origin master
git checkout $FABRIC_GIT_HASH
if [ ! -d $FABRIC_PATH/fabric/gotools/build ] ; then
    cd $FABRIC_PATH/fabric/gotools/build
    make
    cp $FABRIC_PATH/fabric/gotools/build/gopath/bin/* $FABRIC_PATH/fabric/build/docker/gotools/bin/
fi

echo 'the fabric prerequisites install ok'
