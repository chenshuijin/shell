#!/bin/bash

if [ ! -x `which brew` ]; then
    echo 'install homebrew'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'install bash-competion'
brew install bash-completion
if [ -f ./profile ];then
    if [ ! -f ~/.profile ];then
	mv ./profile ~/.profile
    fi
fi

echo 'install git flow'
brew install git-flow

echo 'copy user configuration'
cat ./profile > ~/.profile

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


echo 'Your mac has been configed finished, enjoy your work!'
