#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

exec startx

export GPG_TTY=$(tty)
