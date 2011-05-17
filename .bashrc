#!/bin/bash

if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

export EDITOR=/usr/bin/vim
export PATH=$PATH:~/bin
export TERM=xterm-256color

#[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Git
. .git-completion.bash
export PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
