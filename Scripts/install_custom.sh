#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to install custom config      |--/ /-|#
#|-/ /--| Sébastien Graveline                  |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

rustup default stable

# nvim config
if [ -z "~/.config/nvim" ]; then
    git clone https://github.com/Talgarr/kickstart.nvim.git "~/.config/nvim"
else
    cur=$(pwd)
    cd ~/.config/nvim/
    git pull
    cd $cur
fi

# Default kitty
# update-alternatives --config x-terminal-emulator

# PDF google chrome
xdg-mime default google-chrome.desktop application/pdf

# git
if [ -z "~/.ssh/id_ed25519_sk" ]; then
    ssh-keygen -t ed25519-sk -O resident -O "application=ssh:$(hostname)" -C "$(hostname)"
fi
git config --global user.email "graveline.seb@gmail.com"
git config --global user.name "Sebastien Graveline"
git config --global core.editor "nvim"
git config --global gpg.format ssh
git config --global commit.gpgSign true
git config --global user.signingkey ~/.ssh/id_ed25519_sk.pub
