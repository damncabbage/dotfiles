#!/bin/bash -eux

brew install \
  git vim ack ctags sox watch wget rename \
  icu4c \
  postgres \
  ncdu gnu-sed \
  coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc \
  tig \
  caskroom/cask/iterm2 caskroom/cask/caffeine caskroom/cask/vlc caskroom/cask/flux
  # caskroom/cask/virtualbox
  # caskroom/cask/tunnelblick   # Not always needed

echo <<-EOF
  Manually install:
  - iTerm2 <http://www.iterm2.com/#/section/downloads>
  - GHC+Cabal <http://ghcformacosx.github.io/>
  - Tunnelblick <https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release>
  - VLC <http://www.videolan.org/vlc/index.html>
  - Caffeine <http://lightheadsw.com/caffeine/>
EOF

# These make MacOS randomly shut down after being suspended for a while sometimes. :|
#sudo pmset -a destroyfvkeyonstandby 1
#sudo pmset -a standbydelay 300 # 5-minute hibernate countdown

# Make HiDPI mode available for high-res external monitors
# sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true

#wget http://download.virtualbox.org/virtualbox/5.0.10/VirtualBox-5.0.10-104061-OSX.dmg > /tmp/virtualbox.dmg
#open /tmp/virtualbox.dmg
