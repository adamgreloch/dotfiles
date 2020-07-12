xrandr --output Virtual1 --mode 2736x1824_60.00 --scale 1x1

[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

unclutter &

exec dbus-launch --autolaunch=$(cat /etc/machine-id) i3

# exec i3

