#!/bin/sh

export PATH="$PATH:/home/adam/.local/bin"
export PATH="$PATH:/home/adam/scripts"

[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && exec xinit -- vt1 &> ~/.xsession-errors

export GPG_TTY=$(tty)

export NOTESDIR="/home/adam/Pudlo/notatki"
export SEM="/home/adam/Pudlo/studia/I11"

