# LNDR

Server, CLI, and UCAC Solidity contracts.

[![Build
Status](https://travis-ci.org/blockmason/lndr.svg?branch=master)](https://travis-ci.org/blockmason/lndr)

## API

Dev server answering requests at `http://34.202.214.156:80`
Production server answering requests at `http://34.238.20.130`

## Pre-install on Mac

Once XCode and Homebrew are installed, run:
```
curl -sSL https://get.haskellstack.org/ | sh
brew install automake
brew install libtool
brew install postgres
```

## Install

Once you have [stack](https://github.com/commercialhaskell/stack) installed, run the following commands:

```
stack setup
stack build
stack install
```

For `stack install` to register binaries properly, you must have `.local/bin/`
on your `PATH`.

## lndr-backend

[lndr-backend README](lndr-backend/README.md)

## lndr-cli

[lndr-cli README](lndr-cli/README.md)

## UCAC contract

`0x869a8f2c3D22Be392618Ed06C8F548D1D5b5aeD6`
[FriendInDebt.sol README](ucac/README.md)

## deploy process

On AWS ubuntu server. Deploy will be automated soon.

```
# install stack
curl -sSL https://get.haskellstack.org/ | sh

# clone lndr repo
git clone http://github.com/blockmason/lndr.git

# install geth
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
sudo apt-get install autoconf
sudo apt-get install libtool

# install postgres
# add postgres ppa https://www.ubuntuupdates.org/ppa/postgresql?dist=trusty-pgdg


sudo apt-get install postgresql postgresql-contrib libpq-dev
# https://wixelhq.com/blog/how-to-install-postgresql-on-ubuntu-remote-access

# start a local blockchain in the background
cd lndr/ucac
sudo apt-get install npm
sudo npm install -g truffle
npm install
./gethtest.sh &

# install ghc and lndr-server application
cd lndr
stack setup
stack build
```

on a server using EBS, keep in mind that `stack`'s root can be set via an
environment variable:

```
export STACK_ROOT=/data/.stack
```
