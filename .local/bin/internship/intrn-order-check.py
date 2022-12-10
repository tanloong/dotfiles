#!/usr/bin/env python3
# -*- coding=utf-8 -*-
import re
import sys

"""
For each pair, check whether the leading order of the zh and en line, 1.1.1 for example, match with each other.
"""
fn = sys.argv[1]
with open(fn, "r", encoding="utf-8") as f:
    pairs = [pair.split("\n") for pair in f.read().strip().split("\n\n")]

pattern = re.compile(r"^[0-9. ]+")
for i, pair in enumerate(pairs):
    zh, en = pair
    if not (zh == "AmPl" or en == "UnTr"):
        match_zh = pattern.search(zh)
        match_en = pattern.search(en)
        if match_zh and match_en:
            order_zh = match_zh.group()
            order_en = match_en.group()
            if order_zh != order_en:
                print(f"{i*3+1}")
        if bool(match_zh) ^ bool(match_en):
            print(f"{i*3+1}")
