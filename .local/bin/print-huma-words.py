#!/usr/bin/env python3

import sys
from pathlib import Path

"""
读取虎词码表，按码长从大到小输出词汇，单字不会输出。
输出位置为stdout。
"""

p = "/home/tan/projects/dotfiles/.local/share/fcitx5/table/huma-word.txt"

content = Path(p).read_text(encoding="utf8")
d = {}
for line in content.splitlines():
    if not line.strip():
        continue
    try:
        code, word = line.split(" ", maxsplit=1)
    except:
        continue
    d.setdefault(str(len(word)), []).append((code, word))

keys = iter(sorted(d.keys(), key=lambda i: int(i)))
next(keys) # 去掉单字，码长为1
try:
    for k in keys:
        sys.stdout.write(k)
        sys.stdout.write("\n")
        for w in d[k]:
            sys.stdout.write(w[1])
            sys.stdout.write("\n")
        sys.stdout.write("\n")
except BrokenPipeError:
    sys.exit(0)
