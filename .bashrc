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
PATH="node_modules/.bin:$PATH"

# Python
PATH="env/bin:$PATH"

# Stack (Haskell)
PATH="$HOME/.local/bin:$PATH"

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/build/bin" ] ; then
	PATH="$HOME/build/bin:$PATH"
fi

# Haskell
if [ -d "$HOME/.cabal" ]; then
	PATH=".cabal-sandbox/bin:$HOME/.cabal/bin:$PATH"
fi
#if [ -d "$HOME/.mafia/bin/hdevtools/bin" ]; then
#  PATH="$HOME/.mafia/bin/hdevtools/bin:$PATH"
#fi
#if [ -d "$HOME/.haskell-vim-now/bin" ]; then
#  PATH="$HOME/.haskell-vim-now/bin:$PATH"
#fi

if [ -d "/opt/blender" ]; then
	PATH="$PATH:/opt/blender"
fi

if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
  #nvm use 8 2>/dev/null >/dev/null
fi

# Check what we're running on.
[[ `uname -a | grep -ic 'linux'` -gt 0 ]] && export IS_LINUX=1
[[ `uname -a | grep -ic 'darwin'` -gt 0 ]] && export IS_MAC=1

# History
# No duplicate blanks lines
HISTCONTROL=ignoredups:ignorespace

# Append, don't overwrite
shopt -s histappend

HISTSIZE=5000
HISTFILESIZE=10000


# Misc preferences
export EDITOR=$(command -v vim)
#export TERM=xterm-256color
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
#export GIT_PS1_SHOWCOLORHINTS='y'
#export GIT_PS1_SHOWUPSTREAM='auto'
#export GIT_PS1_DESCRIBE_STYLE='contains'
#export color_prompt="yes"
. ~/.git-completion.bash
#export PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
export PS1='\u:\w$(__git_ps1 " (%s)")\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# rbenv
#if [ -d "$HOME/.rbenv" ] ; then
#	# "rbenv" command
#	PATH="$HOME/.rbenv/bin:$PATH"
#	eval "$(rbenv init -)"
#fi

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Set STDERR text to red
#if [ -f "$HOME/lib/stderred.so" ]; then
#	export LD_PRELOAD="$HOME/lib/stderred.so"
#fi

# Load in anything else that's install-specific.
if [ -d "$HOME/.bashrc.d" ]; then
  shopt -s nullglob
  for FILE in "$HOME/.bashrc.d/"*; do
    source "${FILE}"
  done
  shopt -u nullglob
fi

# GHC 8.2.2
#export PATH="$HOME/.stack/programs/x86_64-osx/ghc-8.2.2/bin:${PATH}"

# asdf
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi
if [ -f "/usr/local/opt/asdf/asdf.sh" ]; then
  . "/usr/local/opt/asdf/asdf.sh"
fi

# Global JS tools
if [ -d "$HOME/build/js/node_modules/.bin" ]; then
  export PATH="$PATH:$HOME/build/js/node_modules/.bin"
fi

# ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# SSH Agent
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi


# z
# Most 'frecent' directories, eg.
#   $ z foo         cd to most frecent dir matching foo
#   $ z foo bar     cd to most frecent dir matching foo, then bar
#   $ z -r foo      cd to highest ranked dir matching foo
#   $ z -t foo      cd to most recently accessed dir matching foo
#   $ z -l foo      list all dirs matching foo (by frecency)
. ~/bin/z.sh
