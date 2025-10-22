# Setup

1. `ssh-keygen -t ed25519 -C "albi.benni8@gmail.com"`
  - change the key name according to `.ssh/config` file
2. cat `~/.ssh/<name>.pub`
3. add it to github keys
4. test connection: `ssh -T git@github.com`
