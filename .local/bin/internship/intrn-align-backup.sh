#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# fn_zh="$1"
# fn_en="$2"
# fn_algnd="$3"
fn_zh="$(sed -n '1p' ./.intrn-align_input-files | sed -E -e 's/^\s+//g;s/\s+$//g')"
fn_en="$(sed -n '2p' ./.intrn-align_input-files | sed -E -e 's/^\s+//g;s/\s+$//g')"
fn_algnd="$1"

[ -f "$fn_zh" ] && cp --force "$fn_zh" "$fn_zh".bak
[ -f "$fn_en" ] && cp --force "$fn_en" "$fn_en".bak
[ -f "$fn_algnd" ] && cp --force "$fn_algnd" "$fn_algnd".bak
