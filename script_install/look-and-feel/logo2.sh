#!/bin/bash

# Create logo.txt with Arch Linux ASCII art
mkdir -p ~/.local/share/arch
cat >~/.local/share/arch/logo2.txt <<'EOF'
[1;34m               #
[1;34m              ###
[1;34m             #####
[1;34m             ######
[1;34m            ; #####;
[1;34m           +##.#####               [1;37mArchLinux
[1;34m          +##########      [1;37mKeep it Simple, Stupid. :P
[1;34m         ######[0;34m#####[1;34m##;
[1;34m        ###[0;34m############[1;34m+
[1;34m       #[0;34m######   #######
[0;34m     .######;     ;###;`".
[0;34m    .#######;     ;#####.
[0;34m    #########.   .########`
[0;34m   ######'           '######
[0;34m  ;####                 ####;
[0;34m  ##'                     '##
[0;34m #'                         `#[0m
EOF

echo "Arch Linux logo created at ~/.local/share/arch/logo2.txt"
