#!/usr/bin/env python3
"""WCAG 2.x contrast ratio between colours. Standard library only.

Usage:
  contrast.py '#0B132B' '#F4D6B0'                      one pair
  contrast.py --pairs 'bg=#0B132B' 'text=#F4D6B0' ...  every combination of the named colours

Accepts #RGB and #RRGGBB (the leading # is optional). Exit code 1 if a single
pair fails AA for body text (4.5:1), 2 on bad input, 0 otherwise.
"""
import itertools
import re
import sys

HEX = re.compile(r"^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$")


def parse(value):
    m = HEX.match(value.strip())
    if not m:
        raise ValueError(f"not a hex colour: {value!r}")
    h = m.group(1)
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def luminance(rgb):
    def channel(c):
        c = c / 255
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (channel(c) for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def ratio(a, b):
    la, lb = luminance(parse(a)), luminance(parse(b))
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


def verdict(r):
    if r >= 7:
        return "AAA body, AAA large"
    if r >= 4.5:
        return "AA body, AAA large"
    if r >= 3:
        return "FAIL body, AA large text and UI parts only"
    return "FAIL"


def main(argv):
    if len(argv) >= 2 and argv[0] == "--pairs":
        named = []
        for item in argv[1:]:
            name, sep, value = item.partition("=")
            if not sep:
                name, value = item, item
            parse(value)
            named.append((name, value))
        if len(named) < 2:
            raise ValueError("--pairs needs at least two colours")
        width = max(len(n) for n, _ in named)
        for (n1, v1), (n2, v2) in itertools.combinations(named, 2):
            r = ratio(v1, v2)
            print(f"{n1:<{width}}  on  {n2:<{width}}  {r:5.2f}:1  {verdict(r)}")
        return 0
    if len(argv) == 2:
        r = ratio(argv[0], argv[1])
        print(f"{r:.2f}:1  {verdict(r)}")
        return 0 if r >= 4.5 else 1
    print(__doc__.strip())
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except ValueError as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(2)
