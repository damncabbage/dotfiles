#!/bin/bash -eu

prompt_to_install() {
  local name="$1"
  local cmd="${2:-}"
  if [ ! -z "$cmd" ] && command -v "$cmd" >/dev/null; then
    echo "'$name' already installed."
    return 99
  fi

  echo "Install '$name'? (y/N)";
  local prompt;
  read -r prompt;
  [[ "$(echo "$prompt" | grep -c -i 'y')" -eq 1 ]];
}

prompt_to_install "Homebrew" "brew" && (
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
) || true

# Use brew-bundle to install the contents of the Brewfile
echo 'brew bundle'
brew bundle

prompt_to_install "pika (Colour picker)" && (
  set -x;
  open https://superhighfives.com/pika
) || true

prompt_to_install "obs (Open Broadcaster Software)" && (
  set -x;
  brew cask install obs;
) || true

prompt_to_install "CPU Temp Checker" "osx-cpu-temp" && (
  set -x;
  mkdir -p ~/build
  [[ -d ~/build/osx-cpu-temp ]] || git clone https://github.com/lavoiesl/osx-cpu-temp ~/build/osx-cpu-temp;
  cd ~/build/osx-cpu-temp;
  git checkout 22a86f51fb1c421bafceb0aebc009bd7337982f8 && make && ./osx-cpu-temp && mv -i ./osx-cpu-temp ~/bin/
) || true

prompt_to_install "macOS Preferences" && (
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

  # Make HiDPI mode available for high-res external monitors
  # sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true

  # Set the scroll direction
  #defaults write -g com.apple.swipescrolldirection -bool false

  # Restart settings-affected applications
  for app in Safari Finder Dock Mail; do killall "$app"; done
) || true

cat <<-EOF
  Manually install:
  - VSCode extensions, via ~/dotfiles/support/install_vscode_extensions.sh
  - Try <https://contexts.co/> or <https://github.com/lwouis/alt-tab-macos> ...?
  - Haptic Touch Bar App? <https://www.haptictouchbar.com/> or HapticKey? <https://github.com/niw/HapticKey>
  - Try Yabai <https://github.com/koekeishiya/yabai> ...?
EOF

cat <<-EOF
  Manually configure:
  - Trackpad:
    - Scroll direction
  - Mouse:
    - Mouse speed
  - Keyboard:
    - Shortcut keys for desktop left+right
    - Shortcut keys for Automator actions (eg. leave meeting)
  - Dock:
    - Disable recent apps in Dock.
  - General:
    - Set default browser
    - Set highlight colour
  - Accesibility
    - Mouse zoom
    - Set "Speak selected text"
  - Touchbar:
    - Set "Touchbar shows" to "Expanded control strip"
  - Start Karabiner Elements, Caffeine, etc.
EOF
