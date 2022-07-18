LANG=zh_CN.UTF-8
LANGUAGE=zh_CN:en_US
CLASSPATH=$CLASSPATH:$HOME/software/stanford-corenlp-4.2.0/*
CORENLP_HOME=$HOME/software/stanford-corenlp-4.2.0/
PATH=$PATH:$HOME/software/parser-stanford/
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.local/bin/data-science-utils
PATH=$PATH:/usr/jre1.8.0_301/bin/
PATH=$PATH:$HOME/university/bachelor3/semester3/non-literary-translation/corpus/programs/tregex-stanford
PATH=$PATH:/home/tan/software/rasp3os/scripts
NLTK_DATA=$HOME/software/nltk_data/
TESSDATA_PREFIX=/usr/share/tessdata/
SUDO_ASKPASS=/usr/bin/qt4-ssh-askpass
CDPATH=$HOME:$HOME/university/:$HOME/software:$HOME/projects
CDPATH=$CDPATH:$HOME/university/this-year/current-semester
TERMINAL="st"
PDFVIEWER="zathura"
BROWSER="brave"
FILE_MANAGER="lf"
WORKON_HOME=~/.virtualenvs

# colored GCC warnings and errors
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# fzf
FZF_DEFAULT_COMMAND='ag --path-to-ignore "$HOME/.agignore" --hidden -g "" "$HOME/"'
FZF_DEFAULT_OPTS='--reverse --height=60%'

# source LS_COLORS
[ -f $HOME/.local/share/ls-colors.sh ] && source $HOME/.local/share/ls-colors.sh
# source icons for lf
[ -f $HOME/.local/share/lf-icons.sh ] && source $HOME/.local/share/lf-icons.sh
