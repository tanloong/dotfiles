#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import re
import sys


def segment_sent(s: str) -> str:
    s = re.sub(r"([。！？\?])([^’”])", r"\1\n\2", s)
    s = re.sub(r"(\.{3,})([^’”])", r"\1\n\2", s)
    s = re.sub(r"(\…+)([^’”])", r"\1\n\2", s)
    s = re.sub(r"([。！？][’”])([^，。！？\?])", r"\1\n\2", s)
    s = re.sub(r"(?:\r?\n){2,}", r"\n", s)
    return s


def main():
    if sys.stdin.isatty():
        i_file = sys.argv[1]
        with open(i_file, "r", encoding="utf-8") as f:
            document = f.read()
    else:
        document = sys.stdin.read()
    sents = segment_sent(document)
    sys.stdout.write(sents)


if __name__ == "__main__":
    main()
