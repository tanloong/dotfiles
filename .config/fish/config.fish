function fish_greeting; end
function fish_mode_prompt; end
function fish_prompt
    # if set -q VIRTUAL_ENV
    #     echo -n -s "(" (basename "$VIRTUAL_ENV") ")" " "
    # end
    set_color green
    echo -n "$(whoami)":
    set_color 005fff
    echo -n $(basename $(prompt_pwd))
    set_color normal
    if set -q LF_LEVEL
        echo -n "($LF_LEVEL) "
    end
    echo -n '$ '
end

#set --global --export LANG zh_CN.UTF-8
set --global --export LANG en_US.UTF-8
set --global --export LANGUAGE zh_CN:en_US
set --global --export ALIYUNPAN_CONFIG_DIR $HOME/.config/aliyunpan
set --global --export CORENLP_HOME $HOME/software/stanford-corenlp-4.5.1/
set --global --export STANFORD_PARSER_HOME "/home/tan/.local/share/stanford-parser-full-2020-11-17"
set --global --export STANFORD_TREGEX_HOME "/home/tan/.local/share/stanford-tregex-2020-11-17"
set --global --export JAVA_HOME "/home/tan/.local/share/jdk8u372-b07"
set --global --export PATH $PATH "/home/tan/.local/share/jdk8u372-b07/bin"
set --global --export PATH $PATH $HOME/.local/bin
set --global --export PATH $PATH $HOME/.local/bin/data-science-utils
set --global --export PATH $PATH $HOME/.local/bin/internship
set --global --export PATH $PATH /home/tan/software/rasp3os/scripts
set --global --export PATH $PATH $STANFORD_TREGEX_HOME $STANFORD_PARSER_HOME
set --global --export NLTK_DATA $HOME/software/nltk_data/
set --global --export TESSDATA_PREFIX /usr/share/tessdata/
set --global --export SUDO_ASKPASS /usr/bin/lxqt-openssh-askpass
# set --global --export CDPATH $HOME $HOME/university/ $HOME/software $HOME/projects $HOME/docx
# set --global --export CDPATH $CDPATH $HOME/projects/.shangwai/
set --global --export TERMINAL "terminal.sh"
set --global --export PDFVIEWER "zathura"
set --global --export BROWSER "browser.sh"
set --global --export FILE_MANAGER "lf"
set --global --export WORKON_HOME ~/.virtualenvs
set --global --export OPENAI_API_KEY $(cat $HOME/.config/api_keys/OPENAI_API_KEY 2> /dev/null || echo "")
set --global --export OPENAI_API_BASE $(cat $HOME/.config/api_keys/OPENAI_API_BASE 2> /dev/null || echo "")
set --global --export OPENAI_API_HOST $(cat $HOME/.config/api_keys/OPENAI_API_HOST 2> /dev/null || echo "")
set --global --export ZHIPU_API_KEY $(cat $HOME/.config/api_keys/ZHIPU_API_KEY 2> /dev/null || echo "")
set --global --export ZHIPU_API_BASE $(cat $HOME/.config/api_keys/ZHIPU_API_BASE 2> /dev/null || echo "")
# set --global --export GROQ_API_KEY $(cat $HOME/.config/api_keys/GROQ_API_KEY 2> /dev/null || echo "")
# set --global --export GROQ_API_BASE $(cat $HOME/.config/api_keys/GROQ_API_BASE 2> /dev/null || echo "")

# scaling
# set --global --export GDK_SCALE 1.25
# set --global --export GDK_DPI_SCALE 0.8
# set --global --export QT_AUTO_SCREEN_SET_FACTOR 0
# set --global --export QT_SCALE_FACTOR 1.25
# if [ "$XDG_SESSION_TYPE"="wayland" ]
#     set --global --export QT_QPA_PLATFORM wayland
# end

# colored GCC warnings and errors
set --global --export GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# fzf
set --global --export FZF_DEFAULT_COMMAND 'rg --ignore-file "$HOME/.ignore" --files --hidden -L'
set --global --export FZF_DEFAULT_OPTS '--tiebreak=end,chunk --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --info=inline-right --layout=reverse --tabstop=1 --exit-0 --select-1'
set --global --export _ZO_FZF_OPTS '--scheme=path --tiebreak=end,chunk --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --info=inline-right --layout=reverse --tabstop=1 --exit-0 --select-1'

# display icons properly for CJK environment in Lf: https://github.com/gokcehan/lf/issues/583
set --global --export RUNEWIDTH_EASTASIAN 0

bind --mode default \ce edit_command_buffer
bind --mode insert \ce edit_command_buffer

# source LS_COLORS
# [ -f $HOME/.local/share/ls-colors.sh ] && source $HOME/.local/share/ls-colors.sh

function fzf_with
    set file "$(fzf --reverse)"
    if test -e "$file";
        set --function abspath $(readlink -f "$file")
        set --function dir "$(path dirname $abspath)"
        switch "$argv[1]"
            case cd
                builtin cd "$dir"
            case '*'
                "$argv[1]" "$abspath"
        end
    end
end

function fv; fzf_with "$EDITOR"; end
function fcd; fzf_with cd; end
function fz; fzf_with "$PDFVIEWER"; end
function fr; fzf_with "$FILE_MANAGER"; end

# Use neovim for vim if present.
if command -v nvim > /dev/null
    set --global --export EDITOR "nvim"
    alias vv='cd $HOME/projects/dotfiles/; fv; cd -'
else
    set --global --export EDITOR "vim"
    alias vv='vim $HOME/.vim/vimrc'
end
alias mm='cd $HOME/docx/memorandum/; fv; cd -'

function nq
    if test (count $argv) -eq 0
        echo "usage: nq <pattern>"
        return
    end
    nvim -q (rg --vimgrep --smart-case $argv | psub)
end

alias dl=trash
alias c=clear
alias e=chmod u+x
alias g=git
alias p='sudo pacman'
alias pt=python
alias t=tldr
alias q=exit
alias r='$FILE_MANAGER'
alias L="less"
alias .="cd .."
alias ..="cd ../.."
alias lt="du -sh * | sort -h"
alias ka="killall"
alias cd-="cd -"
alias sc="shellcheck"
alias v='$EDITOR'
alias ga="lazygit"
alias jr='$EDITOR $HOME/docx/memorandum/journal.md'
alias wr='cd $HOME/workspace/writing'
alias neofetch='neofetch --config $HOME/.config/neofetch.conf'
alias myclip='xclip -rmlastnl -sel clipboard'
#alias wk="vf activate"
#alias deactivate="vf deactivate"
alias mkvirtualenv="vf new"
alias mktmpenv="vf tmp"
alias rmvirtualenv="vf rm"
alias lsvirtualenv="vf ls"
alias cdvirtualenv="vf cd"
alias cdsitepackages="vf cdpackages"
alias add2virtualenv="vf addpath"
alias allvirtualenv="vf all"
alias setvirtualenvproject="vf connect"
alias j="jupyter"
alias jt="jupyter nbconvert --to script"
alias jn="jupyter-notebook"
if test -n (command -v newsboat)
  alias n="newsboat"
end

function activate
    set --function cwd (pwd)
    set --function home (dirname (realpath $HOME))
    set --function venv_path ""

    # Recursive search upward for .venv directory
    while test -n $cwd -a $home != $cwd
        if test -e $cwd/.venv
            set --function venv_path (realpath $cwd/.venv)
            break
        end
        set --function cwd (dirname $cwd)
    end

    if test -n $venv_path
        if test -d $venv_path
            source $venv_path/bin/activate.fish
        else
            echo "Found .venv at $venv_path, but it is not a valid directory"
        end
    else
        echo "Could not find .venv directory"
    end
end
alias va="activate"
alias vd="deactivate"

# aliases that precedes with "setsid -f"
alias deskreen="setsid -f deskreen"
alias za="setsid -f zathura"
alias xournalpp="setsid -f xournalpp"
alias x="setsid -f xournalpp"
alias zathura="setsid -f zathura"
alias rstudio="setsid -f rstudio-bin"
alias spyder="setsid -f spyder"
alias wechat="setsid -f wechat"
alias QQ="setsid -f linuxqq"
alias et="setsid -f et"
alias wps="setsid -f wps"
alias wpp="setsid -f wpp"
alias snd="setsid -f bluetooth-sendto"
alias libreoffice="setsid -f libreoffice"
alias texdoc="setsid -f texdoc"
alias sxiv="setsid -f sxiv"
alias s="setsid -f sxiv"
alias brave="setsid -f brave"
alias gimp="setsid -f gimp"
alias virtualbox="setsid -f virtualbox"
alias mpv="mpv --no-terminal"
alias R="R --quiet --no-save"

# Verbosity and settings that you pretty much just always are going to want.
alias cp="cp -iv"
alias mv="mv -iv"
alias grep="grep --color"
alias mkd="mkdir -pv"
alias ls='ls -hN --color=auto --group-directories-first'
alias diff='diff --color=auto'

set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

function mcd
    set --function newdir '_mcd_command_failed_'
    if test -d "$argv[1]"       # Dir exists, mention that...
        echo "$argv[1] exists..."
        set --function newdir "$argv[1]"
    else
        if test -n "$argv[2]"     # We've specified a mode
            command mkdir -p -m $argv[1] "$argv[2]" && set --function newdir "$argv[2]"
        else                     # Plain old mkdir
            command mkdir -p "$argv[1]" && set --function newdir "$argv[1]"
        end
    end
    builtin cd "$newdir"         # No matter what, cd into it
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# LS_COLORS
set --local ls_color_path $HOME/.local/share/ls-colors.txt
if test -e $ls_color_path
    set --global --export LS_COLORS $(cat $ls_color_path)
end
set fish_color_valid_path normal --underline
set fish_color_command green
set fish_color_error red --bold
set fish_color_param normal
set fish_color_comment normal
set fish_color_selection --reverse

zoxide init fish | source
