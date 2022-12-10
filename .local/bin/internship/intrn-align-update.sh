#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_zh="$1"
fn_en="$2"
fn_algnd="$3"

[ -f "$fn_zh" ] && cp --force "$fn_zh" "$fn_zh".bak
[ -f "$fn_en" ] && cp --force "$fn_en" "$fn_en".bak
[ -f "$fn_algnd" ] && cp --force "$fn_algnd" "$fn_algnd".bak

sed -E -n '1~3p' "$fn_algnd" | sed -e '/^---$/d; /^$/d' > "$fn_zh"
sed -E -n '2~3p' "$fn_algnd" | sed -e '/^---$/d; /^$/d' > "$fn_en"

paste -d '\n' "$fn_zh" "$fn_en" | sed -E '0~2G' > "$fn_algnd"
