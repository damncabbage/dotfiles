#!/bin/bash
# For interactively-running bash terminals.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Import from the global blob
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

## Helpers
prepend_path_if_exists() {
  if [ ! -z "$1" ] && [ -d "$1" ]; then
    # Add $2 if provided, otherwise use $1
    export PATH="${2:-$1}:$PATH"
  fi
}

# Check what we're running on.
[[ `uname -a | grep -ic 'linux'` -gt 0 ]] && export IS_LINUX=1
[[ `uname -a | grep -ic 'darwin'` -gt 0 ]] && export IS_MAC=1

## Setup scripts
# asdf
#if [ -f "$HOME/.asdf/asdf.sh" ]; then
#  . "$HOME/.asdf/asdf.sh"
#  . "$HOME/.asdf/completions/asdf.bash"
#fi
#if [ -f "/usr/local/opt/asdf/asdf.sh" ]; then
#  . "/usr/local/opt/asdf/asdf.sh"
#fi
#if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
#  . "/opt/homebrew/opt/asdf/libexec/asdf.sh"
#fi

# mise
if [ -f "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate bash)"
fi

# Rust/Cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Node.js
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
  #nvm use 8 2>/dev/null >/dev/null
fi

## Plain $PATH manip
# Node.js
prepend_path_if_exists "$HOME/node_modules/.bin"
export PATH="$PATH:node_modules/.bin"

# - Bun
export BUN_INSTALL="$HOME/.bun"
prepend_path_if_exists "$BUN_INSTALL/bin"

# Python
prepend_path_if_exists "$HOME/env/bin"

# Haskell
prepend_path_if_exists "$HOME/.local/bin" # Stack
prepend_path_if_exists "$HOME/.cabal" "$HOME/.cabal-sandbox/bin:$HOME/.cabal/bin"

# MacOS GNU
prepend_path_if_exists "/opt/homebrew/opt/grep/libexec/gnubin"
prepend_path_if_exists "/opt/homebrew/opt/binutils/bin"

# Misc Homebrew keg-only libs
prepend_path_if_exists "/opt/homebrew/opt/icu4c/bin"
prepend_path_if_exists "/opt/homebrew/opt/icu4c/sbin"

# Ruby-build with Mise
prepend_path_if_exists "/usr/local/opt/ruby/bin"

# Misc
prepend_path_if_exists "/opt/blender"
prepend_path_if_exists "$HOME/.platformio/penv/bin"

# Set PATH so it includes user's private bin if it exists
prepend_path_if_exists "$HOME/bin"
prepend_path_if_exists "$HOME/build/bin"

# History
# No duplicate blanks lines
HISTCONTROL=ignoredups:ignorespace

# Append, don't overwrite
shopt -s histappend

HISTSIZE=5000
HISTFILESIZE=10000


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

# Homebrew completions
#if [ -d /opt/homebrew/etc/bash_completion.d ] && ! shopt -oq posix; then
#  for ii in /opt/homebrew/etc/bash_completion.d/*; do
#    . "$ii"
#  done
#fi


## Git
# Git Prompt
. ~/.git-completion.bash
export PS1='robin:\w$(__git_ps1 " (%s)")\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# Hook installation
export GIT_TEMPLATE_DIR="$(undercommit template-dir)"

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Set STDERR text to red
#if [ -f "$HOME/lib/stderred.so" ]; then
#  export LD_PRELOAD="$HOME/lib/stderred.so"
#fi

# ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# SSH Agent
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi

# Homebrew
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  # Stop homebrew removing everything all the bloody time
  export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
  # and this
  export HOMEBREW_NO_AUTO_UPDATE=true

  # Fixing a diesel-cli install for Rust
  #export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"
  # ... which causes problems for some homebrew apps. yay.
fi

# Alias 'thefuck' to something more pleasant.
eval $(thefuck --alias "please")

# AWS
export SAM_CLI_TELEMETRY=0

# MacOS Bash warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# z
# Most 'frecent' directories, eg.
#   $ z foo         cd to most frecent dir matching foo
#   $ z foo bar     cd to most frecent dir matching foo, then bar
#   $ z -r foo      cd to highest ranked dir matching foo
#   $ z -t foo      cd to most recently accessed dir matching foo
#   $ z -l foo      list all dirs matching foo (by frecency)
. ~/bin/z.sh

#export PATH="$HOME/.platformio/penv/bin:$PATH"

# Misc preferences
export EDITOR=$(command -v nvim)
export LESS="R" # Have 'less' interpret/use colour codes
#export TERM=xterm-256color
if [ $IS_MAC ]; then
  export GREP_OPTIONS="--color=auto"
fi
if [ $IS_MAC ]; then
  export CLICOLOR=1
fi

# Load in anything else that's install-specific.
if [ -d "$HOME/.bashrc.d" ]; then
  shopt -s nullglob
  for FILE in "$HOME/.bashrc.d/"*; do
    source "${FILE}"
  done
  shopt -u nullglob
fi
