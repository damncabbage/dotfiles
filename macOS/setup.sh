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
    gnu-sed # because BSD sed is still Bad™
    exa # 'ls' but not awful

    coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc # a bunch of tools need these for compilation
    icu4c # some library everything needs

    postgres

    asdf
    gpg # needed for asdf-nodejs
    shellcheck # sh/bash linter
    tig # git history viewer

    bat # cat with syntax highlighting
    direnv # pull environment variables from .envrc files
    entr # file-watcher; use with pipes, eg. while true; do find . -name "*.js" | entr -dcs 'eslint'; done
    fzf # fuzzy-finder, good for CLI tools
    hexyl # hexdump but better
    httpie # user-friendly curl alternative, eg. http PUT http://my/url foo=bar
    hyperfine # benchmarking
    jq # JSON parser + queries
    gron # Greppable JSON
    mdcat # cat markdown
    ncdu # Hard-disk space spelunking
    pastel # colour tool
    pstree # 'pstree -p $$' is my "am I in a bash session in a vim session in a bash session" checker
    pv # pipe-viewer, for progress of copies and the like
    ripgrep # ack/grep but fast and some bugs fixed
    starship # prompt config
    thefuck # aliased as 'please'

    sox # audio tools

    exiftool # image tools
    imagemagick # convert anything to anything, badly

    terminal-notifier # macOS notifications
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

prompt_to_install "overcommit (Git Hooks Management)" && (
  set -x;
  gem install overcommit;
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

# Pomodoro
prompt_to_install "thyme" && (
  set -x;
  sudo gem install thyme;
);

cat <<-EOF
  Manually install:
  - HazeOver (App Store)
  - MacSVG (App Store)
  - VSCode <https://code.visualstudio.com/docs/setup/mac>
    - With extensions, via ~/dotfiles/support/install_vscode_extensions.sh
  - Spectacle? (App Store...?)
  - Try <https://contexts.co/> or <https://github.com/lwouis/alt-tab-macos> ...?
  - Haptic Touch Bar App? <https://www.haptictouchbar.com/> or HapticKey? <https://github.com/niw/HapticKey>
EOF

cat <<-EOF
  Manually configure:
  - Scroll direction
  - Shortcut keys for desktop left+right
  - Shortcut keys for Automator actions (eg. leave meeting)
EOF

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
