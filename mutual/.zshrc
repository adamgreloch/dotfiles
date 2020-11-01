# Start tmux on SSH session
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh || tmux new-session -s ssh
fi

# Start tmux on every shell login
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	tmux new-session -d -s 0 || tmux new-session -t 0 \; set-option destroy-unattached
fi

# Enable colors and change prompt:
autoload -U colors && colors
#PS1="%B%~%b $ "
PS1="%B%c%b $ "
#RPROMPT="%F{09} %T%f"

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[5 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[1 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[1 q"
}
zle -N zle-line-init
echo -ne '\e[1 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[1 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

alias ls='ls -a --color=auto'
alias mv='mv -v'
# alias cp='cp -v'\
alias cp='rsync --info=progress2'
alias rm='rm -I'
alias v='vim'
alias vi3='vim .config/i3/config'
alias vpol='vim .config/polybar/config'
alias vxr='vim .Xresources'
alias shdn='shutdown now'

if [[ -n "$SSH_CONNECTION" ]]; then
	alias vim='vim -X'
fi

export PATH="$PATH:/usr/local/texlive/2020/bin/x86_64-linux"
MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH; export MANPATH
INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH; export INFOPATH
RANGER_LOAD_DEFAULT_RC=FALCE:$RANGER_LOAD_DEFAULT_RC; export RANGER_LOAD_DEFAULT_RC

export PATH="/home/adam/.local/bin:$PATH"
export TERMINAL=xterm-256color
export EDITOR=vim
export VISUAL=vim
export PF_INFO="ascii title os kernel uptime pkgs shell wm memory"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
#export FZF_DEFAULT_COMMAND='ag'
export FZF_CTRL_T_COMMAND="ag"
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null


