#####################
# zsh-newuser-install
#####################
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL=ignoreboth
setopt nomatch correct
unsetopt beep extendedglob notify
# Reloads the history whenever you use it
setopt share_history
# vi mode
bindkey -v
bindkey -s '^R' '$FILE_MANAGER\n'

#############
# compinstall
#############
zstyle :compinstall filename '/home/tan/.zshrc'
zstyle ':completion:*' menu select

autoload -U mcd
autoload -U zmv
autoload -Uz compinit
compinit
autoload -U select-word-style
select-word-style bash

# comment lines beginning with `#`
# remember to put "ZSH_HIGHLIGHT_STYLES[comment]='none'" in /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
setopt interactive_comments

# 不保存重复的历史记录项
setopt hist_save_no_dups
setopt hist_ignore_dups

# ^Xe 用$EDITOR编辑命令
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# python-virtualenvwrapper
source /usr/bin/virtualenvwrapper_lazy.sh

# aliases
source $HOME/.config/aliasrc

# functions
fpath=($HOME/.local/share/zsh_functions/ $fpath)

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

bindkey '^u' backward-kill-line
bindkey '^w' backward-kill-word
bindkey '^h' backward-delete-char
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
export STANFORD_PARSER_HOME="/home/tan/.local/share/stanford-parser-full-2020-11-17"
export STANFORD_TREGEX_HOME="/home/tan/.local/share/stanford-tregex-2020-11-17"
