#!/bin/bash -eux

prompt_to_install () {
  echo "Install '${1}'?";
  local PROMPT;
  read -r PROMPT;
  [[ "$(echo "$PROMPT" | grep -c -i 'y')" -eq 1 ]];
}

(
  set -x;

  PACKAGES=(
    git vim ack ctags watch wget rename # the basics
    coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc # a bunch of tools need these for compilation
    sox # audio tools
    icu4c # some library everything needs
    exiftool # image tools
    postgres
    ncdu # Hard-disk space spelunking
    gnu-sed # because BSD sed is still Bad™
    imagemagick # convert anything to anything, badly
    tig # git history viewer
    terminal-notifier # macOS notifications
    jq # JSON parser + queries
    pv # pipe-viewer, for progress of copies and the like
    asdf
    direnv
    pstree # 'pstree -p $$' is my "am I in a bash session in a vim session in a bash session" checker
    shellcheck # sh/bash linter
    fzf # fuzzy-finder, good for CLI tools
    gpg # needed for asdf-nodejs
    httpie # user-friendly curl alternative, eg. http PUT http://my/url foo=bar
    pastel # colour tool
    entr # file-watcher; use with pipes, eg. while true; do find . -name "*.js" | entr -dcs 'eslint'; done
  )
  brew install "${PACKAGES[@]}"

  CASK_PACKAGES=(
    caffeine # keep the machine awake
    sim-daltonism # colour-blindness/a11y tool
    focuswriter # ignore the void for a while
    karabiner-elements # messing with key bindings
    muzzle # turn off notifications during talks/streams
    flux # because Night Shift has bugs when you have multiple monitors
    glueprint # translucent always-on-top image hovering, when you're nostalgic for working at a design agency implementing pixel-perfect designs
    # virtualbox
    # aws-vault
    # tunnelblick
  )
  brew cask install "${CASK_PACKAGES[@]}"
)

prompt_to_install "obs ('Open Broadcaster Software')" && (
  set -x;
  brew cask install obs;
)

prompt_to_install "slowquitapps" && (
  set -x;
  brew tap dteoh/sqa;
  brew cask install slowquitapps;
);

prompt_to_install "docker" && (
  set -x;
  brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve;
  sudo chown root:wheel "$(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve";
  sudo chmod u+s "$(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve";
  docker-machine create default --driver xhyve --xhyve-experimental-nfs-share;
  eval "$(docker-machine env default)";
  echo "Docker started on: $(docker-machine ip default)";
);

cat <<-EOF
  Manually install:
  - Haptic Touch Bar App? <https://www.haptictouchbar.com/> or HapticKey? <https://github.com/niw/HapticKey>
  - GHC+Cabal <http://ghcformacosx.github.io/>
  - Tunnelblick <https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release>
EOF

# Pomodoro
prompt_to_install "thyme" && (
  set -x;
  sudo gem install thyme;
);

# CPU Temp tool
mkdir -p ~/build
(
  set -x;
  [[ -d ~/build/osx-cpu-temp ]] || git clone https://github.com/lavoiesl/osx-cpu-temp ~/build/osx-cpu-temp;
  cd ~/build/osx-cpu-temp;
  git checkout 22a86f51fb1c421bafceb0aebc009bd7337982f8 && make && ./osx-cpu-temp && mv -i ./osx-cpu-temp ~/bin/
)


### macOS settings
(
  set -x;

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
