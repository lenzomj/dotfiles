![CI](https://github.com/lenzomj/dotfiles/workflows/CI/badge.svg)
![ShellCheck](https://github.com/lenzomj/dotfiles/workflows/ShellCheck/badge.svg)
![Vint](https://github.com/lenzomj/dotfiles/workflows/Vint/badge.svg)

# Install
```bash
git clone https://github.com/lenzomj/dotfiles.git
dotfiles/install.sh $HOME
```
# Uninstall
```bash
dotfiles/uninstall.sh $HOME
```
# Manual Actions

## Install Vim Plugins
```bash
# Vim
vim +'PlugInstall --sync' +qa

# Neovim
nvim --headless +PlugInstall +qall
```

## Add GitHub Public Key
```bash
curl https://github.com/web-flow.gpg | gpg --import
gpg --edit-key noreply@github.com trust quit
```
