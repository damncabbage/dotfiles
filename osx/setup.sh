#!/bin/bash -eux

brew install \
  git vim ack ctags sox watch wget rename \
  icu4c \
  exiftool \
  postgres \
  ncdu \
  gnu-sed \
  coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc \
  imagemagick \
  tig \
  terminal-notifier \
  jq \
  asdf \
  direnv \
  gpg # needed for asdf-nodejs

brew cask install \
  caffeine \
  sim-daltonism \
  focuswriter \
  karabiner-elements
  # virtualbox
  # aws-vault
  # tunnelblick

echo "Install slowquitapps?"
if [ "$(read -r | grep -c -i 'y')" -eq 1 ]; then
  brew tap dteoh/sqa && brew cask install slowquitapps
fi

cat <<-EOF
  Manually install:
  - Haptic Touch Bar App? <https://www.haptictouchbar.com/> or HapticKey? <https://github.com/niw/HapticKey>
  - GHC+Cabal <http://ghcformacosx.github.io/>
  - Tunnelblick <https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release>
EOF

# Pomodoro
sudo gem install thyme

# CPU Temp tool
mkdir -p ~/build
(
  [[ -d ~/build/osx-cpu-temp ]] || git clone https://github.com/lavoiesl/osx-cpu-temp ~/build/osx-cpu-temp;
  cd ~/build/osx-cpu-temp;
  git checkout 22a86f51fb1c421bafceb0aebc009bd7337982f8 && make && ./osx-cpu-temp && mv -i ./osx-cpu-temp ~/bin/
)


### macOS settings
(
  # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Expand save panel by default
  defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

  # Expand print panel by default
  defaults write -g PMPrintingExpandedStateForPrint -bool true

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

  # Avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # Disable Safari’s thumbnail cache for History and Top Sites
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeDebugMenu -bool true

  # Show the ~/Library folder
  chflags nohidden ~/Library

  # Dim hidden apps
  defaults write com.apple.dock showhidden -bool true

  # These make MacOS randomly shut down after being suspended for a while sometimes. :|
  #sudo pmset -a destroyfvkeyonstandby 1
  #sudo pmset -a standbydelay 300 # 5-minute hibernate countdown

  # Make HiDPI mode available for high-res external monitors
  # sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true

  # Restart settings-affected applications
  for app in Safari Finder Dock Mail; do killall "$app"; done
)
