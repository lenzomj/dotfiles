# Zero Day Checklist
These checklists are intended to configure a new development environment.

## CentOS 7
- [ ] Clone `.dotfiles` repository and update submodules
```bash
git clone git@github.com:mjlenzo/dotfiles.git ~/.dotfiles
git submodule update --recursive --init
```
- [ ] Install and configure terminal fonts
```bash
ln -s .dotfiles/fonts .fonts
fc-cache -vf .fonts
```
- [ ] Edit terminal profile and select an appropriate powerline font
- [ ] Wire-up vim configuration files and directories
```bash
ln -s .dotfiles/common.vimrc .vimrc
ln -s .dotfiles/vim.d .vim
```
- [ ] Install vim plugins using the `:PluginInstall` command
- [ ] Install zsh using `sudo yum install zsh`
- [ ] Wire-up zsh configuration files
```bash
ln -s .dotfiles/common.zshrc .zshrc
```
- [ ] Install tmux using `sudo yum install tmux`
- [ ] Wire-up tmux configuration file
```bash
ln -s .dotfiles/linux.tmux.conf .tmux.conf
```
- [ ] Wire-up git configuration file
```bash
ln -s .dotfiles/common.gitconfig .gitconfig
touch .gitconfig-local
```
- [ ] Wire-up module files
```bash
ln -s .dotfiles/modules .modules
mkdir .modules-local
```
- [ ] Wire-up `bashrc` and `bash_profile`
```bash
ln -s .dotfiles/common.bashrc .bashrc
ln -s .dotfiles/common.bash_profile .bash_profile
```
