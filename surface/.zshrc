# Start tmux on SSH session
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t 0 || tmux new-session -s 0
fi

# Start tmux on every shell login
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	tmux new-session -d -s 0; tmux new-session -t 0 \; set-option destroy-unattached
fi

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%c%b $ "

# History in cache directory:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files.

# ----- vi mode -----
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
    echo -ne '\e[2 q'
  fi
}
zle -N zle-keymap-select

function zle-line-init {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[2 q"
}
zle -N zle-line-init
echo -ne '\e[2 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[2 q' ;} # Use beam shape cursor for each new prompt.

function cd_with_fzf {
    cd $HOME
    cd "$(fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)"
    clear && echo "$PWD" && tree -L 1
    zle reset-prompt
}
zle -N cd_with_fzf
bindkey '^o' cd_with_fzf

function cd_up {
    cd .. && print "" && ls
    zle reset-prompt
}
zle -N cd_up
bindkey '^u' cd_up

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# Run GPG agent
GPG_TTY=$(tty)
export GPG_TTY

# PATH settings
export PATH="/home/adam/.local/bin:$PATH"
export EDITOR=vim
export VISUAL=vim
export PF_INFO="ascii title os kernel uptime pkgs shell wm memory"

# Add texlive to PATH
export PATH="$PATH:/usr/local/texlive/2021/bin/x86_64-linux"
MANPATH=/usr/local/texlive/2021/texmf-dist/doc/man:$MANPATH; export MANPATH
INFOPATH=/usr/local/texlive/2021/texmf-dist/doc/info:$INFOPATH; export INFOPATH
RANGER_LOAD_DEFAULT_RC=FALCE:$RANGER_LOAD_DEFAULT_RC; export RANGER_LOAD_DEFAULT_RC

# FZF variables
export FZF_DEFAULT_COMMAND="fd -H"
export FZF_COMPLETION_TRIGGER=''

# opam configuration
test -r /home/adam/.opam/opam-init/init.zsh && . /home/adam/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

source /usr/share/fzf/shell/key-bindings.zsh
