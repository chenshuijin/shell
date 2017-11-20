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

echo 'Your mac has been configed finished, enjoy your work!'
