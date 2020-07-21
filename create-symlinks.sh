#!/bin/sh

if [ "$1" != "surface-vm" -a "$1" != "desktop" ]; then
	echo "Are you sure that configuration for $1 exists? Because I'm not"
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

