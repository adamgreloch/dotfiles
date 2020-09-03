#
# ~/.zprofile
#

[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec startx

export GPG_TTY=$(tty)


# Created by `userpath` on 2020-08-16 22:40:14
export PATH="$PATH:/home/adam/.local/bin"

