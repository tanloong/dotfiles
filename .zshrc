#####################
# zsh-newuser-install
#####################
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL=ignoreboth
setopt nomatch correct
unsetopt beep extendedglob notify
bindkey -v

#############
# compinstall
#############
zstyle :compinstall filename '/home/tan/.zshrc'

autoload -U mcd
autoload -U zmv
autoload -Uz compinit
compinit

# python-virtualenvwrapper
source /usr/bin/virtualenvwrapper_lazy.sh

# aliases
    source $HOME/.config/aliasrc

# functions
    fpath=($HOME/.local/share/zsh_functions/ $fpath)

# source icons for lf
    [ -f ~/.local/share/icons ] && source ~/.local/share/icons

# display the last folder of the current working directory, but shorten the homedir to ~
PS1='%F{green}%n%f:%B%F{#005fff}%1~%f%b$ '

# Warn about nested lf instances
[ -n "$LF_LEVEL" ] && PS1="${PS1%' '}""($LF_LEVEL) "

[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Remove mode switching delay.
    KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]   ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]]  ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]]     ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
_fix_cursor() { echo -ne '\e[5 q' }
precmd_functions+=(_fix_cursor)

# Ctrl-w - delete a full WORD (including colon, dot, comma, quotes...)
    my-backward-kill-word () {
        # Add colon, comma, single/double quotes to word chars
        local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>:,"'"'"
        zle -f kill # Append to the kill ring on subsequent kills.
        zle backward-kill-word
    }
    zle -N my-backward-kill-word
    bindkey '^w' my-backward-kill-word
    bindkey '^u' backward-kill-line
    bindkey '^?' backward-delete-char
# to fix the delete key in st
    bindkey '^[[P' delete-char
    bindkey -M vicmd '^[[P' vi-delete-char
    bindkey -M visual '^[[P' vi-delete

# https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory
function osc7 {
    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7
stty -ixon
