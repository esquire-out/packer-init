#!/bin/bash
curl https://pyenv.run | bash

sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev llvm

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv install $(pyenv install -l | grep -v 'nogil' |  grep -E '3\.[0-9]\.[0-9][0-9]' | tail -n 1)
pyenv global $(pyenv install -l | grep -v 'nogil' |  grep -E '3\.[0-9]\.[0-9][0-9]' | tail -n 1)
