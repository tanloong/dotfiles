#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_zh="$1"
fn_en="$2"
fn_algnd="$3"

[ -f "$fn_zh" ] && cp --force "$fn_zh" "$fn_zh".bak
[ -f "$fn_en" ] && cp --force "$fn_en" "$fn_en".bak

sed -E -n '1~3p' "$fn_algnd" | sed '/---/d' | tr --squeeze-repeats '\n' > "$fn_zh"
sed -E -n '2~3p' "$fn_algnd" | sed '/---/d' | tr --squeeze-repeats '\n' > "$fn_en"
