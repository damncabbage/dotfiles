#!/usr/bin/env bash

shopt -s expand_aliases

# Aliases to import
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Programmable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Load in anything else that's install-specific.
if [ -d "$HOME/.bashrc.d" ]; then
  shopt -s nullglob
  for FILE in "$HOME/.bashrc.d/"*; do
    source "${FILE}"
  done
  shopt -u nullglob
fi

