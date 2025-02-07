#!/usr/bin/env python3

import argparse
import re
import sys

"""
Usage:
  1. cat /file/path | python <script.py> -
  2. python <script.py> /file/path
"""

def split_sentences(text):
    # sentence boundaries
    pattern = re.compile(r"([…。｡．!！?？]+[」﹂”』’》）\]］｝〕〗〙〛〉】]*)")
    return pattern.sub(r"\1\n", text).strip()

def main():
    parser = argparse.ArgumentParser(description="中文分句")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("filepath", nargs="?", help="Read text from filepath")
    group.add_argument(
        "-",
        action="store_true",
        dest="is_stdin",
        default=False,
        help="Read text input from stdin",
    )
    args = parser.parse_args()

    if args.is_stdin:
        text = sys.stdin.read()
    elif args.filepath is not None:
        with open(args.filepath, encoding="utf-8") as f:
            text = f.read()
    else:
        parser.print_help()
        sys.exit(1)

    sys.stdout.write(split_sentences(text))

if __name__ == "__main__":
    main()
