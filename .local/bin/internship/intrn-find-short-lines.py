#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import sys
fn = sys.argv[1]
num = int(sys.argv[2])
with open(fn,'r') as f:
    for i,line in enumerate(f.readlines()):
        if len(line.strip()) < num:
            print(i+1)
            print(line)
            print('-'*80)
