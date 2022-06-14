#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import requests
import os
import sys
import subprocess


def Open_or_not(fn: str):
    feedback = input("Do you want to open it with sxiv? (y/n) ")
    if feedback == "y":
        subprocess.Popen(f"sxiv -s w {fn}", shell=True)

def get_char():
    #  char = sys.argv[1]
    #  return char


def main():
    char = get_char()
    dir_o = os.path.expanduser("~/.local/share/五笔拆字图解/")
    fn_o = dir_o + "{}.gif".format(char)

    if not os.path.exists(fn_o):
        url = "https://www.52wubi.com/wbbmcx/tp/{}.gif".format(char)
        res = requests.get(url)
        if res.status_code == 200:
            with open(fn_o, "wb") as f:
                f.write(res.content)
            #  print("Written in {}.".format(fn_o))
    #  else:
    #      print("{} already exists.".format(fn_o))
    subprocess.Popen(f"sxiv -s w {fn_o}", shell=True)
    #  Open_or_not(fn_o)


if __name__ == "__main__":
    main()
