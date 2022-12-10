#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import sys
import time
from stanza.server import CoreNLPClient


def segment_sent_en(intext: str, client):
    ann = client.annotate(intext)
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
    if sys.stdin.isatty():
        i_file = sys.argv[1]
        o_file = i_file.rstrip(".txt") + ".segmented.txt"
        with open(i_file, "r", encoding="utf-8") as f:
            document = f.read()
    else:
        document = sys.stdin.read()
        o_file = "sents_{}.txt".format(
            time.strftime("%Y-%m-%d-%H-%M-%S", time.localtime())
        )

    with CoreNLPClient(
        properties={
            "annotators": "ssplit",
            "ssplit.newlineIsSentenceBreak": "always",
            "quiet": True,
        },
        max_char_length=10000000,
    ) as client:
        sents = segment_sent_en(document, client)
    with open(o_file, "w", encoding="utf-8") as f:
        f.write(sents)


if __name__ == "__main__":
    main()
