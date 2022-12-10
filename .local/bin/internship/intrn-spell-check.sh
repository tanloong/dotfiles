#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fn_input_txt="$1"
#fn_input_pdf="${1/.txt}".pdf
fn_output_badspell="badspell.txt"
#fn_output_non_existing="non-existing.txt"

aspell list -l en < "$fn_input_txt" |\
sort |\
uniq |\
sed -E -e 's/^ +//g; /^[A-Z]/d' > "$fn_output_badspell"

#total=$(wc -l "$fn_output_badspell" | awk '{print $1}')
#i=1
#[ -f "$fn_output_non_existing" ] && rm "$fn_output_non_existing"
#while read -r word; do
#    echo "$i"/"$total"
#    [ -z "$(pdfgrep --files-with-matches --perl-regexp '[^0-9a-zA-Z-]'"$word"'[^0-9a-zA-Z-]' "$fn_input_pdf")" ] &&\
#        echo "$word" >> "$fn_output_non_existing"
#    ((i++))
#done < badspell.txt
