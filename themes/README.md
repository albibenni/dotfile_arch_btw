# Themes

All Omarchy themes ported to your dotfiles structure.

## Available Themes

**14 themes** with **~40MB total** of wallpapers and configs:

- **tokyo-night** (8.1M) - Dark blue theme with cyan accents
- **osaka-jade** (5.1M) - Green/jade aesthetic
- **hackerman** (4.7M) - Matrix-style green on black
- **matte-black** (3.7M) - Pure black minimalist
- **rose-pine** (3.2M) - Soho vibes, muted colors
- **ristretto** (3.1M) - Warm espresso tones
- **nord** (2.7M) - Arctic, frost-inspired palette
- **catppuccin** (2.5M) - Pastel dark theme
- **kanagawa** (2.2M) - Japanese-inspired colors
- **ethereal** (2.0M) - Soft, dreamy aesthetic
- **catppuccin-latte** (1.3M) - Light version of catppuccin
- **gruvbox** (1.1M) - Retro groove colors
- **flexoki-light** (872K) - Light theme
- **everforest** (812K) - Forest green theme

## Theme Structure

Each theme contains:

```
theme-name/
├── hyprland.conf      # Hyprland colors (borders, etc.)
├── waybar.css         # Bar colors
├── mako.ini           # Notification colors
├── walker.css         # Launcher colors
├── ghostty.conf       # Ghostty terminal colors
├── kitty.conf         # Kitty terminal colors
├── alacritty.toml     # Alacritty terminal colors
├── neovim.lua         # Neovim theme name
├── vscode.json        # VS Code theme
├── btop.theme         # btop system monitor theme
├── swayosd.css        # OSD (volume/brightness) theme
├── preview.png        # Theme preview image
└── backgrounds/       # Wallpapers for this theme
```

## Usage

### List themes
```bash
themeList
```

### Check current theme
```bash
themeCurrent
```

### Set a theme
```bash
themeSet tokyo-night
```

### Change background (random from current theme)
```bash
themeNextBg
```

### Interactive picker (uses fzf)
```bash
themePicker
```

### Preview a theme
```bash
themePreview gruvbox
```

## How It Works

Themes use a **symlink system**:

1. `~/dotfiles/themes/` - All themes stored here (git-tracked)
2. `~/.config/current-theme` - Symlink pointing to active theme
3. Your configs source from `~/.config/current-theme/*`

### Example

When you run `themeSet gruvbox`:
1. Creates symlink: `~/.config/current-theme → ~/dotfiles/themes/gruvbox`
2. Your configs automatically use the new theme files
3. Restarts Waybar, Hyprland, Mako, etc. to apply changes

## Integration with Your Configs

Add these lines to your config files to use themes:

### Hyprland
```bash
# In ~/.config/hypr/hyprland.conf
source = ~/.config/current-theme/hyprland.conf
```

### Waybar
```css
/* In ~/.config/waybar/style.css */
@import "../../current-theme/waybar.css";
```

### Mako
```ini
# In ~/.config/mako/config
[include]
~/.config/current-theme/mako.ini
```

### Ghostty
```
# In ~/.config/ghostty/config
import = ~/.config/current-theme/ghostty.conf
```

### Walker
```css
/* In ~/.config/walker/style.css */
@import "../../current-theme/walker.css";
```

## Creating Custom Themes

1. Copy an existing theme:
```bash
cd ~/dotfiles/themes
cp -r tokyo-night my-theme
```

2. Edit the color files in `my-theme/`

3. Add your own wallpapers to `my-theme/backgrounds/`

4. Apply it:
```bash
themeSet my-theme
```

## Theme Variables Reference

### Hyprland (hyprland.conf)
```bash
$activeBorderColor = rgba(33ccffee) rgba(00ff99ee) 45deg

general {
    col.active_border = $activeBorderColor
    col.inactive_border = rgba(595959aa)
}
```

### Waybar (waybar.css)
```css
@define-color foreground #cdd6f4;
@define-color background #1a1b26;
@define-color accent #7aa2f7;
```

### Mako (mako.ini)
```ini
background-color=#1a1b26
text-color=#cdd6f4
border-color=#7aa2f7
```

## Tips

- **Quick switch**: Use `themePicker` with fzf for visual selection
- **Background cycling**: Run `themeNextBg` to cycle wallpapers
- **Preview first**: Use `themePreview <name>` to see before applying
- **Git-tracked**: All themes are in your dotfiles repo

## Troubleshooting

**Theme not applying?**
```bash
# Check symlink
ls -la ~/.config/current-theme

# Manually reload
hyprctl reload
restartWaybar
makoctl reload
```

**Missing wallpapers?**
```bash
# Check backgrounds directory
ls ~/dotfiles/themes/$(themeCurrent)/backgrounds
```

**Functions not found?**
```bash
# Reload bash config
source ~/.bashrc
```
