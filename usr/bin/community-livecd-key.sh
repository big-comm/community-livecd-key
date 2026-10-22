#!/usr/bin/env bash
# Puts the keyring shipped by community-livecd-key in place: the live session
# can verify packages without populating its keyring on every boot.

source=/usr/share/pacman/keyrings
target=/etc/pacman.d/gnupg

say() { echo -e "\e[1;38;5;33m[\e[1;38;5;39mcommunity-livecd-key\e[1;38;5;33m]\e[0m \e[1;38;5;45m→\e[0m \e[1;97m$*\e[0m"; }

mkdir -p "$target"
for file in pubring.gpg trustdb.gpg; do
    if [[ -e $source/$file ]]; then
        cp -af "$source/$file" "$target/$file"
    else
        say "$source/$file not found" >&2
    fi
done
pacman-key --init >/dev/null 2>&1
say "pacman keyring ready"
