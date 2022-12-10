# export LANG=zh_CN.UTF-8
# export LANG=en_US.UTF-8
# export LANGUAGE=zh_CN:en_US
#CLASSPATH=/usr/lib/jvm/java-18-jdk/bin/*

export JAVA_HOME=/usr/lib/jvm/default
export CORENLP_HOME=$HOME/software/stanford-corenlp-4.5.1/
export STANFORD_PARSER_HOME=/home/tan/software/stanford-parser-full-2020-11-17
export STANFORD_TREGEX_HOME=/home/tan/software/stanford-tregex-4.2.0
export PATH=$PATH:$STANFORD_TREGEX_HOME:$STANFORD_PARSER_HOME

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/data-science-utils
export PATH=$PATH:$HOME/.local/bin/internship
export PATH=$PATH:/usr/jre1.8.0_301/bin/
export PATH=$PATH:/home/tan/software/rasp3os/scripts
export NLTK_DATA=$HOME/software/nltk_data/
export TESSDATA_PREFIX=/usr/share/tessdata/
export SUDO_ASKPASS=/usr/bin/qt4-ssh-askpass
export CDPATH=$HOME:$HOME/university/:$HOME/software:$HOME/projects:$HOME/document
export CDPATH=$CDPATH:$HOME/university/this-year/current-semester
export CDPATH=$CDPATH:$HOME/projects/.shangwai/
export TERMINAL="st"
export PDFVIEWER="zathura"
export BROWSER="brave"
export FILE_MANAGER="lf"
export WORKON_HOME=~/.virtualenvs

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# fzf
export FZF_DEFAULT_COMMAND='ag --path-to-ignore "$HOME/.agignore" --hidden -g "" "$HOME/"'
export FZF_DEFAULT_OPTS='--reverse --height=60%'

export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

export http_proxy=127.0.0.1:7890
export https_proxy=127.0.0.1:7890

# source LS_COLORS
[ -f $HOME/.local/share/ls-colors.sh ] && source $HOME/.local/share/ls-colors.sh
