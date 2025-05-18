![CI](https://github.com/lenzomj/dotfiles/workflows/CI/badge.svg)
![ShellCheck](https://github.com/lenzomj/dotfiles/workflows/ShellCheck/badge.svg)
![Vint](https://github.com/lenzomj/dotfiles/workflows/Vint/badge.svg)

# Setup

## 1. Clone and Run Setup
```bash
git clone https://github.com/lenzomj/dotfiles.git
dotfiles/setup.sh $HOME
```

## 2. Install Essential Tools
```bash
python -m ensurepip --upgrade
python -m pip install --user -r playbook/requirements.txt
```

## 3. Install Optional Tools
```bash
ansible-playbook playbook-getctags.yml
ansible-playbook playbook-getnodejs.yml
ansible-playbook playbook-getneovim.yml
```

# How-To

## Install Vim Plugins
```bash
# Vim
vim +'PlugInstall --sync' +qa

# Neovim
nvim --headless +PlugInstall +qall
```

## Add Personal Public Key
```bash
# Manual
gpg --import <public_key>.asc

# Keyserver
gpg --recv $KEYID

gpg --edit-key $KEYID
gpg --card-status
```

## Add GitHub Public Key
```bash
curl https://github.com/web-flow.gpg | gpg --import
gpg --edit-key noreply@github.com trust quit
```

## Create Git-based Encrypted Vault
```bash
pass init $GPG_KEYID
cd $HOME/.password-store
git init && git config user.email "me@email.domain"
remote add origin git@github.com:me/vault.git
```

# Uninstall
```bash
dotfiles/setup.sh -u $HOME
```
