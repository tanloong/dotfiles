#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_zh="$1"
fn_en="$2"
fn_interlaced="$(date +%F-%H%M%S)".interlaced.txt

paste -d '\n' "$fn_zh" "$fn_en" | sed -E '0~2G' > "$fn_interlaced"
nvim "$fn_interlaced"
