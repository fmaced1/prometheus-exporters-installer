#!/bin/sh
# see manpage for sshpass usage: https://linux.die.net/man/1/sshpass

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "${machine}" = "Linux" ]
then
    echo " ---> Setting up ansible, sshpass ..."
    sudo apt-get install sshpass ansible -y
fi

if [ "${machine}" = "Mac" ]
then
    if [ "$(which brew)" = '' ]
    then
        echo " ---> Homebrew installation not detected, please first install homebrew"
        exit 1
    else
        echo " ---> Setting up ansible, sshpass ..."
        brew install ansible
        tar -xzf sshpass-1.06.tar.gz \
            && cd sshpass-1.06/ \
            && ./configure
    fi
fi