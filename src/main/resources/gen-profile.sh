#!/bin/bash

################################################################################
# Generate .profile or .zshrc based on the user's shell                       #
# This script merges modular dotfiles into one unified profile file           #
################################################################################

# Define input files
INPUT_FILES=(
  .aliasesrc
  .bowerrc
  .dirrc
  .git-aliases
  .gulprc
  .mvnrc
  .npmrc
  .tweak.sh
  .zipping
)

# Detect user shell
SHELL_NAME=$(basename "$SHELL")
TARGET_FILE="$HOME/.profile"

if [[ "$SHELL_NAME" == "zsh" ]]; then
  TARGET_FILE="$HOME/.zshrc"
fi

# Announce action
echo "🔧 Generating config for shell: $SHELL_NAME"
echo "📄 Output file: $TARGET_FILE"
echo "🔍 Combining the following files:"

# Combine files
> "$TARGET_FILE"
for file in "${INPUT_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    echo "  ✅ $file"
    cat "$file" >> "$TARGET_FILE"
    echo -e "\n" >> "$TARGET_FILE"
  else
    echo "  ⚠️  Skipping missing file: $file"
  fi
done

echo "✅ Profile generated successfully!"
