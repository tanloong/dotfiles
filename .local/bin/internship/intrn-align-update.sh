#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# fn_zh="$1"
# fn_en="$2"
# fn_algnd="$3"
fn_zh="$(sed -n '1p' ./.intrn-align_input-files | sed -E -e 's/^\s+//g;s/\s+$//g')"
fn_en="$(sed -n '2p' ./.intrn-align_input-files | sed -E -e 's/^\s+//g;s/\s+$//g')"
fn_algnd="$1"

sed -E -n '1~3p' "$fn_algnd" | sed -e '/^---$/d; /^$/d' > "$fn_zh"
sed -E -n '2~3p' "$fn_algnd" | sed -e '/^---$/d; /^$/d' > "$fn_en"

paste -d '\n' "$fn_zh" "$fn_en" | sed -E '0~2G' > "$fn_algnd"
