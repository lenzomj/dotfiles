#!/bin/bash

# Banner Function - Prints a nice box around text
Banner () {
  echo $@ | sed -e 's/^/../' -e 's/$/../' -e 's/./*/g'
  echo $@ | sed -e 's/^/* /' -e 's/$/ */'
  echo $@ | sed -e 's/^/../' -e 's/$/../' -e 's/./*/g'
}

# Script Entry-Point
clear
Banner ".dotfiles Shell Configuration Script"

echo "--- Checking paths ---"
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "*** Error: Directory $HOME/.dotfiles does not exist! Exiting ..."
  exit 1
fi

echo "--- Checking for existing symlinks ---"
files=".bash_profile .emacs .emacs.d"

for i in $files
do
  if [ -e "$HOME/$i" ]; then
    read -p "*** Query: $i already exists ... overwrite? (y/n)"
    [[ "$REPLY" == [yY] ]] && rm -r "$HOME/$i" || { continue; }
  fi
  echo "--- $HOME/$i >> $HOME/.dotfiles/$i --- "
  ln -s "$HOME/.dotfiles/$i" "$HOME/$i"
done