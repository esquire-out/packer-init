#!/bin/bash

sudo apt update; sudo apt install build-essential curl \
 libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5


curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
source ~/.zshrc
ghcup install cabal
