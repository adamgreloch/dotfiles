#!/bin/sh
[[ -f ~/.Xresources ]] && xrdb -merge -I $HOME ~/.Xresources
dbus-update-activation-environment --systemd DISPLAY #fixes pinentry not appearing

xset s 1200
exec xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
exec redshift &
exec picom &
exec unclutter --timeout 3 &
$HOME/.fehbg &
exec $HOME/.cache/xmonad/xmonad-x86_64-linux
