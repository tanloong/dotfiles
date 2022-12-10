#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_in="$1"
fn_out="${1/.txt}".tmp
cat "$fn_in" |\
    perl -CIOED -p -e \
    's/(\p{Block=CJK_Unified_Ideographs}) +(\p{Block=CJK_Unified_Ideographs})/\1\2/g;s/(\p{Block=CJK_Unified_Ideographs}) +(\p{Block=CJK_Unified_Ideographs})/\1\2/g;' |\
    tr --squeeze-repeats '\n' |\
    tr --squeeze-repeats ' ' > "$fn_out"

mv --force "$fn_out" "$fn_in"
