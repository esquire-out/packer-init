#!/bin/bash

sudo apt update
sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

git clone https://github.com/neovim/neovim

cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

echo $(nvim --version)
