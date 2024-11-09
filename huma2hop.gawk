BEGIN {
  PROCINFO["sorted_in"] = "@ind_str_asc" ;
  printf("-- Simplified Chinese Huma\nreturn {\n") ;
  is_skip = 1 ;
}
 
$0 !~ /\[Data\]|\[数据\]/ && is_skip == 1 { next }
$0 ~ /\[Data\]|\[数据\]/ {is_skip = 0; next }

{ code = substr($1, 1, 1); arr[code][$2] = 1; }
 
END {
  for (code in arr) {
    printf("  ['%s'] = [=[", code) ;
    for (char in arr[code]) { printf("%s", char) };
    printf("]=],\n")
  };
    printf("}")
}
