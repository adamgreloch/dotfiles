[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I $HOME ~/.Xresources

export QT_AUTO_SCREEN_SCALE_FACTOR=0
wal -R
exec i3


