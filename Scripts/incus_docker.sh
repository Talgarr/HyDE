#!/bin/sh

incus launch images:archlinux docker-runner -c security.nesting=true
incus exec docker-runner -- pacman-key --init
incus exec docker-runner -- pacman-key --populate archlinux
incus exec docker-runner -- pacman -Syu --noconfirm
incus exec docker-runner -- pacman -S docker docker-compose --noconfirm
incus exec docker-runner -- systemctl enable --now docker.service
