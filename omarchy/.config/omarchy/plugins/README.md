# Custom Omarchy shell plugins

Each subdirectory is a user-owned Quickshell plugin. Keep these files in the
dotfiles repository, then deploy them as real directories under
`~/.config/omarchy/plugins/` (not symlinks).

Use the deployment helper from the repository root:

```bash
./omarchy/.config/omarchy/scripts/omarchy-plugin sync albibenni.cpu right
```

`sync` validates the dotfiles source, copies it with `rsync --delete` only
within that plugin's live directory, validates the live copy, adds it to the
selected bar section if needed, and reloads Quickshell. Edit the files here,
then run `sync`; do not edit only the live copy.

Useful commands:

```bash
# Validate source and (when installed) the live copy.
./omarchy/.config/omarchy/scripts/omarchy-plugin validate albibenni.cpu

# Show source/live/layout state.
./omarchy/.config/omarchy/scripts/omarchy-plugin status albibenni.cpu

# Temporarily hide/show a plugin without deleting its live files.
./omarchy/.config/omarchy/scripts/omarchy-plugin disable albibenni.cpu
./omarchy/.config/omarchy/scripts/omarchy-plugin enable albibenni.cpu right

# Force Quickshell to reload plugins.
./omarchy/.config/omarchy/scripts/omarchy-plugin rescan
```

To show a widget, add its id to a section of `~/.config/omarchy/shell.json`:

```json
{ "id": "albibenni.cpu" }
```

`albibenni.cpu` samples `/proc/stat` every two seconds and displays total CPU
usage as a percentage.
