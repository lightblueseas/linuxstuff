#!/usr/bin/env bash

###############################################################################
# install.sh                                                                  #
# Sets up the user's environment by:                                          #
# - Detecting the shell (bash or zsh)                                         #
# - Generating the appropriate profile                                        #
# - Ensuring it's sourced in .bashrc or .zshrc                                #
# - Sourcing init_scripts.sh for compatibility                               #
###############################################################################

set -e

# Detect base directory (e.g. src/main/resources)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Load init scripts
INIT_SCRIPTS="$SCRIPT_DIR/../scripts/linux/init_scripts.sh"

if [[ -f "$INIT_SCRIPTS" ]]; then
  echo "🧠 Sourcing init_scripts.sh..."
  source "$INIT_SCRIPTS"
else
  echo "❌ init_scripts.sh not found at $INIT_SCRIPTS"
  exit 1
fi

# Detect the user's shell
SHELL_NAME=$(basename "$SHELL")
TARGET_PROFILE="$HOME/.profile"
RC_FILE="$HOME/.bashrc"

if [[ "$SHELL_NAME" == "zsh" ]]; then
  TARGET_PROFILE="$HOME/.zshrc"
  RC_FILE="$HOME/.zshrc"
fi

echo "🔍 Detected shell: $SHELL_NAME"
echo "📄 Generating profile: $TARGET_PROFILE"

# Run gen-profile.sh
if [[ -f "./gen-profile.sh" ]]; then
  bash ./gen-profile.sh
else
  echo "❌ gen-profile.sh not found in $SCRIPT_DIR"
  exit 1
fi

# Ensure the generated profile is sourced in RC file
if ! grep -qF "source $TARGET_PROFILE" "$RC_FILE"; then
  echo "🔗 Adding 'source $TARGET_PROFILE' to $RC_FILE"
  echo -e "\n# Source generated profile\nsource $TARGET_PROFILE" >> "$RC_FILE"
else
  echo "✅ $RC_FILE already sources $TARGET_PROFILE"
fi

echo "✅ Installation complete!"
echo "💡 Please run 'source $RC_FILE' to apply changes now."
