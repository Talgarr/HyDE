#!/bin/sh
# https://blog.simos.info/how-to-run-a-windows-virtual-machine-on-incus-on-linux/

incus init win11vm --empty --vm
incus config device override win11vm root size=200GiB
incus config set win11vm limits.cpu=4 limits.memory=8GiB
incus config device add win11vm install disk source=/home/talgarr/Documents/vm/tiny11.incus.iso boot.priority=10
incus start win11vm --console=vga
incus console win11vm --type=vga

read "Finish install windows and enter"
incus config device remove win11vm install

