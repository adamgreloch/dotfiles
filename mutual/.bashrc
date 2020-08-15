#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

GPG_TTY=$(tty)
export GPG_TTY

alias ls='ls -a --color=auto'
alias rm='rm -I'
#alias shutdown='sudo shutdown -h now'
#PS1='[\u@\h \W]\$ '

PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH; export PATH
MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH; export MANPATH
INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH; export INFOPATH
RANGER_LOAD_DEFAULT_RC=FALCE:$RANGER_LOAD_DEFAULT_RC; export RANGER_LOAD_DEFAULT_RC

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

