[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# exec dbus-launch --autolaunch=$(cat /etc/machine-id) i3

wal -R

exec i3

# exec bspwm

