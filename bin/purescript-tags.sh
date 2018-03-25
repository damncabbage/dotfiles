#!/bin/bash -eux

if command -v purs >/dev/null; then
  purs docs --format=ctags \
    'src/**/*.purs' \
    'bower_components/purescript-*/src/**/*.purs' \
    >> tags
elif command -v psc-docs >/dev/null; then
  psc-docs --format=ctags \
    'src/**/*.purs' \
    '.loom/purs/purescript-*/src/**/*.purs' \ 
    >> tags
else
  echo 'No PureScript found!'
fi
