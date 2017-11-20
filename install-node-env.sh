#!/bin/bash

ifeq ($(OS),Windows_NT)
    IS_WINDOWA:=true
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        apt install npm
    endif
    ifeq ($(UNAME_S),Darwin)
        brew install npm
    endif
endif

npm install -g prettier
