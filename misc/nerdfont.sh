#!/bin/bash

sudo apt-get install fontconfig
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
cp *.ttf ~/.local/share/fonts/
fc-cache -f -v
fc-list | grep "JetBrains Mono"
