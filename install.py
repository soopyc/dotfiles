# This script skips a lot of steps for stuff like file detection.
# don't judge, deal with it.
# I don't like, and in fact, hate these kind of code bc they just shove
# everything into a single file but i don't want this repo to become a
# complete python repo, so there's this abomination.
# 
# Copyright (c) 2021 kcomain, Licensed with MIT

import os
import sys
import typing
import subprocess


def shell(cmd: typing.Union[str, typing.Iterable]):
    if type(cmd) == str:
        cmd = cmd.split()

    process = subprocess.run(cmd)
    return process


def main():
    return


if __name__ == '__main__':
    sys.exit(main)
