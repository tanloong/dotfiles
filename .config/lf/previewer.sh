#!/usr/bin/env bash

case "$1" in
    *.xlsx) ;;
    *.tgz|*.tar.gz) tar tzf "$1";;
    *.tar.bz2|*.tbz2) tar tjf "$1";;
    *.tar.txz|*.txz) xz --list "$1";;
    *.tar) tar tf "$1";;
    *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.[1-8]) man "$1" | col -b ;;
    *.o) nm "$1" | less ;;
    *.torrent) transmission-show "$1";;
    *.iso) iso-info --no-header -l "$1";;
    *odt|*.ods|*.odp|*.sxw) odt2txt "$1";;
    *.doc) catdoc "$1" ;;
    *.docx) docx2txt "$1" - ;;
    # *.csv) cat "$1" | sed s/,/\\n/g ;;
    *.pdf) pdftotext -l 10 -nopgbrk -q "$1" -;;
    *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.flac) exiftool "$1";;
    *.jpg|*.jpeg|*.png|*.mp4) mediainfo "$1";;
    # *.json) jq --color-output . "$1";;
    *) bat --color=always --style=numbers,changes --theme=base16 --line-range=:"$3" "$1" || highlight -O truecolor -s molokai --force -l --line-range=1-"$3" "$1" || cat "$1";;
esac
