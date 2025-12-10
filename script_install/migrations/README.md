# System Migrations

This directory contains migration scripts that run during `system-update.sh`.

## How It Works

Similar to Omarchy's migration system, this allows you to run one-time setup scripts after updates.

### Migration Naming

Use Unix timestamps for migration names:
```bash
# Create a new migration
date +%s
# Output: 1733762400

# Create migration file
touch 1733762400-description.sh
chmod +x 1733762400-description.sh
```

### Migration Structure

```bash
#!/usr/bin/env bash
# Description: Brief description of what this migration does

set -euo pipefail

# Your migration code here
echo "Running migration: Description"

# Example: Update a configuration file
if [ -f ~/.config/app/config.conf ]; then
    sed -i 's/old_setting/new_setting/g' ~/.config/app/config.conf
    echo "✓ Updated app configuration"
fi
```

### Migration State

- **Completed**: `~/.local/state/migrations/TIMESTAMP.sh`
- **Skipped**: `~/.local/state/migrations/skipped/TIMESTAMP.sh`

### Example Migrations

See example files in this directory for common migration patterns.

## Best Practices

1. **Always use `set -euo pipefail`** to catch errors
2. **Check if file exists** before modifying
3. **Provide clear output** about what changed
4. **Keep migrations idempotent** (safe to run multiple times)
5. **Use timestamps** for ordering

## Creating a Migration

```bash
#!/usr/bin/env bash
# Create a new migration script

TIMESTAMP=$(date +%s)
DESCRIPTION="$1"

if [ -z "$DESCRIPTION" ]; then
    echo "Usage: $0 <description>"
    echo "Example: $0 update-waybar-config"
    exit 1
fi

MIGRATION_FILE="$HOME/.config/personal/migrations/${TIMESTAMP}-${DESCRIPTION}.sh"

cat > "$MIGRATION_FILE" <<'EOF'
#!/usr/bin/env bash
# Description: Migration description here

set -euo pipefail

echo "Running migration: DESCRIPTION"

# Your migration code here

echo "✓ Migration completed"
EOF

chmod +x "$MIGRATION_FILE"
echo "✓ Created migration: $(basename "$MIGRATION_FILE")"
echo "Edit it at: $MIGRATION_FILE"
```
