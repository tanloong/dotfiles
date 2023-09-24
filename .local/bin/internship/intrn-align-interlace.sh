#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_zh="$1"
fn_en="$2"
fn_interlaced="$(date +%F-%T)".interlaced.txt

paste -d '\n' "$fn_zh" "$fn_en" | sed -E '0~2G' > "$fn_interlaced"
echo -e "$fn_zh\n$fn_en" > .intrn-align_input-files
nvim "$fn_interlaced"
