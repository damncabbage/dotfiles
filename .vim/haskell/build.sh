#!/bin/bash -eux

SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${SCRIPT_PATH}"

BUILD_PATH="${SCRIPT_PATH}"
BIN_PATH="${BUILD_PATH}/bin"

TEMP_PATH=$(mktemp -d ${BUILD_PATH}/build-XXXX)
  if [ ! -d ".cabal-sandbox" ]; then
    cabal sandbox init
  fi

  mkdir -p "${BIN_PATH}"
  for DIR in data libexec; do
    mkdir -p "${BUILD_PATH}/${DIR}"
  done

  for PACKAGE in ghc-mod hasktags codex hscope hoogle stylish-haskell; do # Excluded: pointfree pointful
    cabal install -j --reorder-goals --disable-documentation --datadir="${BUILD_PATH}/data" --libexecdir="${BUILD_PATH}/libexec" --force-reinstalls "${PACKAGE}"
    if [ "$(ls -1 ./.cabal-sandbox/bin | wc -l)" -gt 0 ]; then
      mv ./.cabal-sandbox/bin/* "${BIN_PATH}/"
    fi
  done
rm -rf "${TEMP_PATH}"

# Configure codex to search in sandboxes
cat > $HOME/.codex <<EOF
hackagePath: .cabal-sandbox/packages/
tagsFileHeader: false
tagsFileSorted: false
tagsCmd: hasktags --extendedctag --ignore-close-implementation --ctags --tags-absolute --output='\$TAGS' '\$SOURCES'
EOF

# Build the Hoogle database
"${BIN_PATH}/hoogle" data
