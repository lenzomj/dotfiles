![CI](https://github.com/lenzomj/dotfiles/workflows/CI/badge.svg)
![ShellCheck](https://github.com/lenzomj/dotfiles/workflows/ShellCheck/badge.svg)
![Vint](https://github.com/lenzomj/dotfiles/workflows/Vint/badge.svg)

# Install
```bash
git clone https://github.com/lenzomj/dotfiles.git
dotfiles/install.sh $HOME
```

# Post-Install

## 1. Install Vim Plugins
```bash
# Vim
vim +'PlugInstall --sync' +qa

# Neovim
nvim --headless +PlugInstall +qall
```

## 2. (Optional) Add Personal Public Key
```bash
# Manual
gpg --import <public_key>.asc

# Keyserver
gpg --recv $KEYID

gpg --edit-key $KEYID
gpg --card-status
```

## 3. (Optional) Add GitHub Public Key
```bash
curl https://github.com/web-flow.gpg | gpg --import
gpg --edit-key noreply@github.com trust quit
```

## 4. (Optional) Create Git-based Encrypted Vault
```bash
pass init $GPG_KEYID
cd $HOME/.password-store
git init && git config user.email "me@email.domain"
remote add origin git@github.com:me/vault.git
```

# Uninstall
```bash
dotfiles/uninstall.sh $HOME
```

# Provisioning
```bash
curl -sSf https://raw.githubusercontent.com/lenzomj/dotfiles/master/playbook/play \
  | bash -s -- -p <profile>
```
