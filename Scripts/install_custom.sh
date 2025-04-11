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


echo "Add Fingerprint"
if ! fprintd-list talgarr | grep '#0' -q; then
    fprintd-enroll
    fprintd-enroll -f right-thumb
else
    echo "Fingerprint already enrolled"
fi
if ! grep -q -E 'auth\s+sufficient\s+pam_fprintd.so' /etc/pam.d/sddm; then
    sudo sed -i "2i auth 			[success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok\nauth 			sufficient  	pam_fprintd.so" /etc/pam.d/sddm
fi
if ! grep -q -E 'auth\s+sufficient\s+pam_fprintd.so' /etc/pam.d/system-local-login; then
    sudo sed -i "2i auth      sufficient pam_fprintd.so" /etc/pam.d/system-local-login
fi
if ! grep -q -E 'auth\s+sufficient\s+pam_fprintd.so' /etc/pam.d/sudo; then
    sudo sed -i "2i auth      sufficient pam_fprintd.so" /etc/pam.d/sudo
fi


echo "Add udev for thunderbolt devices"
sudo cp "${scrDir}/../Source/misc/99-removable.rules" "/etc/udev/rules.d/99-removable.rules"

echo "Set incus"
sudo usermod -v 1000000-1000999999 -w 1000000-1000999999 root
incus config set core.https_address=127.0.0.1:8443
incus remote add docker https://docker.io --protocol=oci

echo "Set hibernation conf"
sudo mkdir /etc/systemd/sleep.conf.d
sudo cp "${scrDir}/../Source/misc/sleep.conf" /etc/systemd/sleep.conf.d/

echo "Add thunderbolt to early module loading. You need to sudo mkinitcpio -P"
sudo sed -i 's/\(MODULES=(.*\))/\1 thunderbolt)/' /etc/mkinitcpio.conf

echo "Add Ghidra desktop shortcut"
cp "${scrDir}/../Source/misc/ghidra.desktop" "$HOME/.local/share/applications/ghidra.desktop"
