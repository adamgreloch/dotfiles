[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

exec xmodmap -e 'remove Mod1 = Alt_L'
exec xmodmap -e 'add Mod3 = Alt_L'

exec i3

