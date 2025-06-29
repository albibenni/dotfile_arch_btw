!#/bin/bash

mkdir -p ~/.local/share/fonts

# Download the NERDFONNTS font files from the specified URL
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/CaskaydiaCoveNerdFont-Regular.ttf
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/CaskaydiaCoveNerdFont-Bold.ttf
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/CaskaydiaCoveNerdFont-Italic.ttf

curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Bold/FiraCodeNerdFont-Bold.ttf
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf


curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Ligatures/Bold/JetBrainsMonoNerdFont-Bold.ttf
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Ligatures/Italic/JetBrainsMonoNerdFont-Italic.ttf
curl -L --output-dir $HOME/Downloads -O https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf

mv $HOME/Downloads/CaskaydiaCoveNerdFont-Regular.ttf ~/.local/share/fonts/
mv $HOME/Downloads/CaskaydiaCoveNerdFont-Bold.ttf ~/.local/share/fonts/
mv $HOME/Downloads/CaskaydiaCoveNerdFont-Italic.ttf ~/.local/share/fonts/

mv $HOME/Downloads/FiraCodeNerdFont-Bold.ttf ~/.local/share/fonts/
mv $HOME/Downloads/FiraCodeNerdFont-Regular.ttf ~/.local/share/fonts/

mv $HOME/Downloads/JetBrainsMonoNerdFont-Italic.ttf ~/.local/share/fonts/
mv $HOME/Downloads/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/
mv $HOME/Downloads/JetBrainsMonoNerdFont-Bold.ttf ~/.local/share/fonts/

# Update the font cache
fc-cache -fv
