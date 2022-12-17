#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import sys
import time
from stanza.server import CoreNLPClient


def segment_sent_en(text: str, client):
    ann = client.annotate(text)
    doc_tokenized = ""
    for sentence in ann.sentence:
        sent_tokenized = "".join(
            [
                token.value + (token.after if not token.after == "\n" else " ")
                for token in sentence.token
            ]
        )
        doc_tokenized += sent_tokenized.rstrip() + '\n'
    return doc_tokenized

def main():
    ifiles = sys.argv[1:]
    with CoreNLPClient(
        properties={
            "annotators": "ssplit",
            "ssplit.newlineIsSentenceBreak": "always",
            "quiet": True,
        },
        max_char_length=10000000,
    ) as client:
        for ifile in ifiles:
            ofile = ifile.rstrip(".txt") + ".segmented.txt"
            with open(ifile, "r", encoding="utf-8") as f:
                text = f.read()
            sents = segment_sent_en(text, client)
            with open(ofile, "w", encoding="utf-8") as f:
                f.write(sents)

if __name__ == "__main__":
    main()
