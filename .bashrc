#!/bin/bash
# For interactively-running bash terminals.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Import from the global blob
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

# Prepend Homebrew/local paths, otherwise things like ctags will always use
# the (rubbish) system-provided version.
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Node.js
PATH="$PATH:node_modules/.bin"
PATH="$PATH:/usr/local/share/npm/bin"

# Python
PATH="$PATH:env/bin"

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/build/bin" ] ; then
	PATH="$HOME/build/bin:$PATH"
fi

# Haskell
if [ -d "/Applications/ghc-7.8.2.app" ]; then
	PATH="/Applications/ghc-7.8.2.app/Contents/bin:$PATH" # OS X install
fi
if [ -d "$HOME/.cabal" ]; then
	PATH=".cabal-sandbox/bin:$HOME/.cabal/bin:$PATH"
fi
if [ -d "$HOME/.haskell-vim-now/bin" ]; then
  PATH="$HOME/.haskell-vim-now/bin:$PATH"
fi

if [ -d "/opt/blender" ]; then
	PATH="$PATH:/opt/blender"
fi

# Check what we're running on.
[[ `uname -a | grep -ic 'linux'` -gt 0 ]] && export IS_LINUX=1
[[ `uname -a | grep -ic 'darwin'` -gt 0 ]] && export IS_MAC=1

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
export GREP_OPTIONS="--color=auto"
if [ $IS_MAC ]; then
  export CLICOLOR=1
fi

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
if [ -d "$HOME/.rbenv" ] ; then
	# "rbenv" command
	PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

# Set STDERR text to red
#if [ -f "$HOME/lib/stderred.so" ]; then
#	export LD_PRELOAD="$HOME/lib/stderred.so"
#fi

# SSH Agent
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi


# Load in anything else that's install-specific.
if [ -d "$HOME/.bashrc.d" ]; then
  for FILE in "$HOME/.bashrc.d/"*; do
    source "${FILE}"
  done
fi
