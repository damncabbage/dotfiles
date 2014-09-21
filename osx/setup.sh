#!/bin/bash

brew install \
  git vim ack ctags sox \
  rbenv ruby-build \
  postgres redis

echo <<-EOF
  Manually install:
  - iTerm2 <http://www.iterm2.com/#/section/downloads>
  - GHC+Cabal <http://ghcformacosx.github.io/>
  - Adium <https://adium.im>
  - Tunnelblick <https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release>
  - VLC <http://www.videolan.org/vlc/index.html>
  - Caffeine <http://lightheadsw.com/caffeine/>
EOF
