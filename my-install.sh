#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 创建自定义目录
home_dirs=(document media/audio/podcast projects software university)
for dir in $home_dirs[@]; do
    mkdir -p "$dir"
done

# 下载常用软件
softs=(git nvim zsh zsh-syntax-highlighting)
sudo pacman -S $softs

# 下载软件仓库
dir="$HOME/software"
url='https://gitee.com/tanloong/'
softs=(dwm st slstatus sxiv dmenu vimium)
for soft in ${softs}; do
    [ -d "$dir/$soft" ] || git clone ${url}/"$soft" "$dir"/"$soft"
done

# 下载dotfiles
dir="$HOME/projects/"
url='https://gitee.com/tanloong/'
[ -d "$dir/dotfiles" ] || git clone ${url}/dotfiles "$dir"/dotfiles
cd $dir/dotfiles && ./link.sh

# 覆盖 /etc/pacman.conf
sudo cp --force ./pacman.conf /etc/pacman.conf
