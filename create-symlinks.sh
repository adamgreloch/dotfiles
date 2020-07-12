#!/bin/sh

if [ "$1" != "surface-vm" -a "$1" != "desktop" ]; then
	echo "Are you sure that configuration for $1 exists? Because I'm not"
	exit 1
fi

read -p "WARNING: This script will overwrite all important dotfiles with symlinks to this repo. Proceed? [Y/n] " -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
	ln -sf $1/ ~/.config
	ln -sf $1/.Xresources ~/.Xresources
	ln -sf $1/.xinitrc ~/.xinitrc
	ln -sf $1/.xprofile ~/.xprofile
	ln -sf mutual/.bash_profile ~/.bash_profile
	ln -sf mutual/.bashrc ~/.bashrc
	ln -sf mutual/.gitconfig ~/.gitconfig
fi

