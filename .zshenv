export LANG=zh_CN.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=zh_CN:en_US

export ALIYUNPAN_CONFIG_DIR=$HOME/.config/aliyunpan
export CORENLP_HOME=$HOME/software/stanford-corenlp-4.5.1/
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/data-science-utils
export PATH=$PATH:$HOME/.local/bin/internship
export PATH=$PATH:$HOME/software/rasp3os/scripts
export PATH=$PATH:$STANFORD_TREGEX_HOME:$STANFORD_PARSER_HOME
export NLTK_DATA=$HOME/software/nltk_data/
export TESSDATA_PREFIX=/usr/share/tessdata/
export SUDO_ASKPASS=/usr/bin/lxqt-openssh-askpass
export CDPATH=$HOME:$HOME/university/:$HOME/software:$HOME/projects:$HOME/docx
export CDPATH=$CDPATH:$HOME/university/this-year/current-semester
export CDPATH=$CDPATH:$HOME/projects/.shangwai/
export TERMINAL="terminal.sh"
export PDFVIEWER="pdfviewer.sh"
export BROWSER="browser.sh"
export OFFICE="office.sh"
export FILE_MANAGER="lf"
export WORKON_HOME=~/.virtualenvs
for file in $HOME/.config/api_keys/*; do export $(basename $file)=$(cat $file); done

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# fzf
export FZF_DEFAULT_COMMAND='rg --ignore-file "$HOME/.ignore" --files'
export FZF_DEFAULT_OPTS='--tiebreak=end,chunk --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --info=inline-right --layout=reverse --tabstop=1 --exit-0 --select-1'
export _ZO_FZF_OPTS='--scheme=path --tiebreak=end,chunk --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right --info=inline-right --layout=reverse --tabstop=1 --exit-0 --select-1'

# export http_proxy=127.0.0.1:7890
# export https_proxy=127.0.0.1:7890

# display icons properly for CJK environment in Lf: https://github.com/gokcehan/lf/issues/583
export RUNEWIDTH_EASTASIAN=0

# source LS_COLORS
[ -f $HOME/.local/share/ls-colors.txt ] && export LS_COLORS=$(cat $HOME/.local/share/ls-colors.txt)
