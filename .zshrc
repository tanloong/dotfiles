#####################
# zsh-newuser-install
#####################
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL=ignoreboth
setopt autocd nomatch
unsetopt beep extendedglob notify
bindkey -v

#############
# compinstall
#############
zstyle :compinstall filename '/home/tan/.zshrc'

autoload -Uz compinit
compinit


# colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# aliases
    source $HOME/.config/aliasrc

# fzf
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore Trash --ignore software --ignore .cache -g "" "$HOME/"'
    export FZF_DEFAULT_OPTS='--reverse --height=60%'
    # source /usr/share/fzf/key-bindings.bash
    # source /usr/share/fzf/completion.bash

# environment variables
    export CLASSPATH=$CLASSPATH:$HOME/software/stanford-corenlp-4.2.0/*
    export PATH=$PATH:$HOME/.local/bin
    export PATH=$PATH:$HOME/.local/bin/data-science-utils
    export PATH=$PATH:/usr/jre1.8.0_301/bin/
    export NLTK_DATA=$HOME/document/corpora/nltk_data/
    export TESSDATA_PREFIX=/usr/share/tessdata/
    export LANG=en_US.UTF-8
    export SUDO_ASKPASS=/usr/bin/qt4-ssh-askpass
    export CDPATH=$HOME:$HOME/curricula/2021-autumn:$HOME/software:$HOME/projects
    export TERMINAL="st"
    export EDITOR="nvim"
    export PDFVIEWER="zathura"
    export BROWSER="brave"

# source icons for lf
    [ -f ~/.local/share/icons ] && source ~/.local/share/icons

# ANSI 8-bit Format Example:
#   di=01;38;5;12
# Explanation:
#   01      bold
#   38;5    use 8-bit code
#   12      8-bit code
#
# Colour map:
# human    3-bit   8-bit
# blue      34      12
# cyan      36      14
# green     32      10
LS_COLORS='rs=0:di=01;38;5;12:ln=01;38;5;14:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=38;5;12;42:st=37;44:ex=01;38;5;10:'
export LS_COLORS

# display the last folder of the current working directory, but shorten the homedir to ~
PS1='%F{green}%n%f:%F{033}%1~%f$ '

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
