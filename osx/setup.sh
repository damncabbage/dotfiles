#!/bin/bash -eux

brew install \
  git vim ack ctags sox watch wget rename \
  icu4c \
  exiftool \
  postgres \
  ncdu gnu-sed \
  coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc \
  imagemagick \
  tig \
  terminal-notifier \
  caskroom/cask/iterm2 \
  caskroom/cask/caffeine \
  caskroom/cask/vlc \
  caskroom/cask/flux \
  caskroom/cask/sim-daltonism \
  caskroom/cask/focuswriter
  # caskroom/cask/virtualbox
  # caskroom/cask/tunnelblick   # Not always needed

echo "Install slowquitapps?"
if [ "$(read -r | grep -c -i 'y')" -eq 1 ]; then
  brew tap dteoh/sqa && brew cask install slowquitapps
fi

cat <<-EOF
  Manually install:
  - iTerm2 <http://www.iterm2.com/#/section/downloads>
  - GHC+Cabal <http://ghcformacosx.github.io/>
  - Tunnelblick <https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release>
  - VLC <http://www.videolan.org/vlc/index.html>
  - Caffeine <http://lightheadsw.com/caffeine/>
EOF

# Pomodoro
gem install thyme

# These make MacOS randomly shut down after being suspended for a while sometimes. :|
#sudo pmset -a destroyfvkeyonstandby 1
#sudo pmset -a standbydelay 300 # 5-minute hibernate countdown

# Make HiDPI mode available for high-res external monitors
# sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true

#wget http://download.virtualbox.org/virtualbox/5.0.10/VirtualBox-5.0.10-104061-OSX.dmg > /tmp/virtualbox.dmg
#open /tmp/virtualbox.dmg

mkdir -p ~/build
(
  git clone https://github.com/lavoiesl/osx-cpu-temp ~/build/osx-cpu-temp;
  cd ~/build/osx-cpu-temp;
  git checkout git22a86f51fb1c421bafceb0aebc009bd7337982f8 && make && ./osx-cpu-temp && mv -i ./osx-cpu-temp ~/bin/
)
