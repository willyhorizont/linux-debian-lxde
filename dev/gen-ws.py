#!/usr/bin/env python3
import sys

args = dict(zip(sys.argv[1::2], map(int, sys.argv[2::2])))

start = args.get("--start", 96)
stop = args.get("--stop", 0)
step = args.get("--step", -1)
curws = args.get("--curws", 69)

print("|".join(f"{num}*" if num == curws else f"{num}" for num in range(start, stop, step)))
