Run after an Omarchy/mise update if task-planner stops resolving:

```bash
bash ~/dotfiles/script_install/fixes/omarchy-post-update.sh          # preview
bash ~/dotfiles/script_install/fixes/omarchy-post-update.sh --apply  # recover
```

The script copies the existing task-planner binary from the newest Go installation
that contains it into `~/.local/bin`. It never downloads software or overwrites an
existing destination. Running it again leaves the recovered binary alone.

The Bash configuration exports `GOBIN=~/.local/bin` and puts it first on PATH before
loading completions. Future `go install` commands from that shell therefore survive
Go version changes. Completion setup only evaluates successful output and keeps
errors visible during shell startup.

Open a new terminal after applying. To rebuild task-planner in future, run its usual
`go install` command from that terminal; it will now update the stable binary.

Optional automation using Omarchy's supported hook:

```bash
mkdir -p ~/.config/omarchy/hooks/post-update.d
cat > ~/.config/omarchy/hooks/post-update.d/task-planner <<'EOF'
#!/usr/bin/env bash
exec bash "$HOME/dotfiles/script_install/fixes/omarchy-post-update.sh" --apply
EOF
chmod +x ~/.config/omarchy/hooks/post-update.d/task-planner
```

The persistent GOBIN setting should make this hook unnecessary after recovery.
