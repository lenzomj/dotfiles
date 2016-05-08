# Zero Day Checklist
These checklists are intended to configure a new development environment.

## CentOS 7
- [ ] Clone `.dotfiles` repository and update submodules
```bash
git clone `git@github.com:mjlenzo/dotfiles.git ~/.dotfiles`
git submodule update --recursive --init
```
- [ ] Wire-up dot configuration files and directories
```bash
cd $HOME
ln -s .dotfiles/common.vimrc .vimrc
ln -s .dotfiles/vim.d .vim
ln -s .dotfiles/linux.tmux.conf .tmux.conf
```
- [ ] Install and configure terminal fonts
```bash
cd $HOME
ln -s .dotfiles/fonts .fonts
fc-cache -vf $HOME/.fonts
```
- [ ] Edit terminal profile and select an appropriate powerline font
- [ ] Install vim plugins using the `:PluginInstall` command
- [ ] Install zsh using `sudo yum install zsh`
