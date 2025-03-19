#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to install custom config      |--/ /-|#
#|-/ /--| Sébastien Graveline                  |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

# nvim config
git clone git@github.com:Talgarr/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Default kitty
update-alternatives --config x-terminal-emulator

# PDF google chrome
xdg-mime default google-chrome.desktop application/pdf

# git
ssh-keygen -t ed25519-sk -O resident -O "application=ssh:$(hostname)" -C "$(hostname)"
git config --global user.email "graveline.seb@gmail.com"
git config --global user.name "Sebastien Graveline"
git config --global core.editor "nvim"
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_sk.pub
