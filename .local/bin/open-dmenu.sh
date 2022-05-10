#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

dmenulines=5
dmenumon="0"
dmenufont="Cousine Nerd Font Mono:pixelsize=20:antialias=true:autohint=true"
col_gray1="#222222"
col_gray3="#bbbbbb"
col_gray4="#eeeeee"
col_cyan="#005577"

dmenu_run -i -l ${dmenulines} -m ${dmenumon} -fn ${dmenufont} -nb ${col_gray1} -nf ${col_gray3} -sb ${col_cyan} -sf ${col_gray4}
