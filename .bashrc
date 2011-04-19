#!/bin/bash

if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

export PATH=$PATH:~/bin
export TERM=xterm-256color

#[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
