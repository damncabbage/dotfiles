#!/bin/bash
#
# Symlinks the contents of the dotfiles path into 
#

# TODO: Replace with a freshrc or something.

function info() {
  echo -e "\033[0;33m --\033[m $*"
}

function success() {
  echo -e "\033[0;32m **\033[m $*"
}

function error() {
  echo -e "\033[1;31m !!\033[m $*"
}

function action() {
  CODE=$1
  shift
  if [ $CODE -gt 0 ]; then
    error $* " (Failed with code $CODE)"
  else
    success $*
  fi
}


# Make sure we're in the same directory as the script
pushd `dirname $0` > /dev/null

  # Make sure submodules are all present before we get started
  git submodule update --init --recursive

  # Can anyone say HACK?
  FILES=".[A-Za-z0-9_][A-Za-z0-9_.]* .config/* bin/* lib/* User/settings.json Services/* chrome/*"
  TARGETDIR=$HOME
  OVERRIDE_TARGETDIR=$TARGETDIR

  for FILE in $FILES
  do
    # HACK: A bunch of exceptions.
    case "$FILE" in
      # It's caught up in the regex above, which is Not Great
      .config) continue;;

      # Ignore our repo .git if this is not a bare repo.
      .git) continue;;
      .gitignore) continue;;

      # Ignore files we'd never want to symlink. (This could be restricted
      # to files in git, but then it's a pain to add and test new things.)
      ._.DS_Store) continue;;
      .DS_Store) continue;;

      # One-off for the VSCode link buried deep in Library/Application Support/Code/User
      User/settings.json)
        OVERRIDE_TARGETDIR="$HOME/Library/Application Support/Code"
        ;;

      # Automator actions.
      Services/*)
        OVERRIDE_TARGETDIR="$HOME/Library"
        ;;

      # Local unpacked extensions
      chrome/*)
        OVERRIDE_TARGETDIR="$HOME/build"
    esac

    # Look, I know these variable names are awful.
    TARGET_JUSTDIR="$OVERRIDE_TARGETDIR/$(dirname "$FILE")"
    TARGET_FULL="$OVERRIDE_TARGETDIR/$FILE"
    if [ -f "$TARGET_FULL" ] || [ -d "$TARGET_FULL" ]; then
      if [ -L "$TARGET_FULL" ]; then
        info "Already symlinked: $FILE"
      else
        error "Already present and is a regular file: $FILE"
      fi

    else
      if [ ! -d "$TARGET_JUSTDIR" ]; then
        mkdir -p "$TARGET_JUSTDIR"
        action $? "Created directory: $TARGET_JUSTDIR"
      fi

      ln -s "`pwd`/$FILE" "$TARGET_JUSTDIR/"
      action $? "Linked: $FILE"
    fi
    OVERRIDE_TARGETDIR=$TARGETDIR
  done

popd > /dev/null
