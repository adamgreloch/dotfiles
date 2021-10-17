#
# ~/.zprofile
#

[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec startx -- vt1 &> /dev/null

export GPG_TTY=$(tty)
export PATH="$PATH:/home/adam/.local/bin"

export NOTESDIR="/home/adam/Pudlo/notatki"
export SEM="/home/adam/Pudlo/studia/I11"

