#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import sys
import stanza


def segment_sent_en(text: str, nlp) -> str:
    doc = nlp(text)
    sents = ""
    for sent in doc.sentences:
        # sents += " ".join(token.text for token in sent.tokens) + "\n"
        sents += sent.text + "\n"
    return sents


def main():
    ifiles = sys.argv[1:]

    nlp = stanza.Pipeline(
        lang="en",
        dir="/home/tan/software/stanza_resources",
        processors="tokenize",
        download_method=None,
    )
    for ifile in ifiles:
        print(f"Segmenting {ifile}")
        ofile = ifile + '.segged'
        with open(ifile, "r", encoding="utf-8") as f:
            text = f.read()
        sents = segment_sent_en(text, nlp)
        with open(ofile, "w", encoding="utf-8") as f:
            f.write(sents)


if __name__ == "__main__":
    main()
