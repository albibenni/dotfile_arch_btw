#!/bin/bash

echo "Updating themes from git repositories..."
echo ""

for dir in ~/dotfiles/themes/*/; do
  if [[ -d $dir ]] && [[ ! -L "${dir%/}" ]] && [[ -d "$dir/.git" ]]; then
    echo "→ Updating: $(basename "$dir")"
    git -C "$dir" pull
    echo ""
  fi
done

echo "✓ Theme updates complete!"

