#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to install custom config      |--/ /-|#
#|-/ /--| Sébastien Graveline                  |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/../Configs/.local/lib/hyde/globalcontrol.sh"


echo "Set rustup to default"
rustup default stable

# nvim config
if [ -z "~/.config/nvim" ]; then
    echo "Install nvim config"
    git clone https://github.com/Talgarr/kickstart.nvim.git "~/.config/nvim"
else
    echo "Update nvim config"
    cur=$(pwd)
    cd ~/.config/nvim/
    git pull
    cd $cur
fi

# Default kitty
# update-alternatives --config x-terminal-emulator

echo "Set default application"
# PDF google chrome
xdg-mime default google-chrome.desktop application/pdf

echo "Setup git config"
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

echo "Setup power management"
# power management
sudo auto-cpufreq --install

echo "Add env variable"
echo 'export EDITOR="nvim"' >> ~/.zshrc

echo "Add wipe hist service"
mkdir -p "$HOME/.config/systemd/user/"
cp ../Source/misc/cliphist-wipe.service "$HOME/.config/systemd/user/"
systemctl --user enable cliphist-wipe.service
systemctl --user start cliphist-wipe.service


echo "SDDM config"
sddm_theme="$(get_hyprConf "SDDM_THEME")"
if [ -f "/etc/sddm.conf.d/the_hyde_project.conf" ]; then
    sudo cp "/etc/sddm.conf.d/the_hyde_project.conf" "/etc/sddm.conf.d/backup_the_hyde_project.conf"
fi
if [ ! -z "$sddm_theme" ]; then
    if [ -f "/usr/share/sddm/themes/$sddm_theme/the_hyde_project.conf" ]; then 
        sudo cp "/usr/share/sddm/themes/$sddm_theme/the_hyde_project.conf" "/etc/sddm.conf.d/the_hyde_project.conf"
    fi
else
    sudo cp "/usr/share/sddm/themes/Candy/the_hyde_project.conf" "/etc/sddm.conf.d/the_hyde_project.conf"
fi
