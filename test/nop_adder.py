#!/usr/bin/env python
# encoding: utf-8
# File Name: a.py
# Author: Jiezhong Qiu
# Create Time: 2014/12/06 15:34
# TODO:

if __name__ == "__main__":
    content = []
    for line in open("./kernel_new_board.txt"):
        instru = line.split(";")[0].strip()
        if len(instru) > 0:
            if instru.startswith("BEQZ") or instru.startswith("BNEZ") or instru.startswith("BTEQZ") or instru.startswith("BTNEZ"):
                for i in xrange(2):
                    content.append("NOP")
            content.append(instru)
    with open("kernel.txt", "w") as f:
        for instru in content:
            print >> f, instru
