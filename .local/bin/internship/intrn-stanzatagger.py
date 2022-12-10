#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import sys
from stanza.server import CoreNLPClient


def tag(intext: str, client):
    ann = client.annotate(intext)
    return "\n".join(
        [
            " ".join(
                [
                    token.value + "_" + token.pos
                    for token in sentence.token
                ]
            )
            for sentence in ann.sentence
        ]
    )


def main():
    infile = sys.argv[1]
    outfile = infile.rstrip(".txt") + ".stanzatagged.txt"
    intext = open(infile, "r").read()
    with CoreNLPClient(
        properties={
            "annotators": "tokenize,ssplit,pos",
            "ssplit.newlineIsSentenceBreak": "always",
        },
        max_char_length=10000000,
    ) as client:
        outtext = tag(intext, client)
    with open(outfile, "w", encoding="utf-8") as f:
        f.write(outtext)


if __name__ == "__main__":
    main()
