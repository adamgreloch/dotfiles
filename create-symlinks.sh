#!/bin/sh

if [ "$1" != "surface-vm" -a "$1" != "desktop" ]; then
	echo "Configuration for $1 does not exist."
	exit 1
fi

read -p "WARNING: This script will overwrite all important dotfiles with symlinks pointing to this repo. Proceed? [Y/n] " -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
	ln -sfr $1/ ~/.configc
	ln -sfr $1/.Xresources ~/.Xresources
	ln -sfr $1/.xinitrc ~/.xinitrc
	ln -sfr $1/.xprofile ~/.xprofile
	ln -sfr mutual/.bash_profile ~/.bash_profile
	ln -sfr mutual/.bashrc ~/.bashrc
	ln -sfr mutual/.gitconfig ~/.gitconfig
fi

