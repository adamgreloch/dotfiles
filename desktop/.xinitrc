[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources


# exec dbus-launch --autolaunch=$(cat /etc/machine-id) i3

exec i3

