#!/bin/bash
# For interactively-running bash terminals.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Import from the global blob
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "/opt/blender" ]; then
	PATH="$PATH:/opt/blender"
fi


# History
# No duplicate blanks lines
HISTCONTROL=ignoredups:ignorespace

# Append, don't overwrite
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000


# Misc preferences
export EDITOR=/usr/bin/vim
export TERM=xterm-256color

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Aliases to import
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Programmable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi


# Git Prompt
. ~/.git-completion.bash
export PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# rbenv
if [ -d "$HOME/.rbenv/bin" ] ; then
	# "rbenv" command
	PATH="$HOME/.rbenv/bin:$PATH"
	# Shim paths
	eval "$(rbenv init -)"
fi

# Set STDERR text to red
#if [ -f "$HOME/lib/stderred.so" ]; then
#	export LD_PRELOAD="$HOME/lib/stderred.so"
#fi

