#!/usr/bin/env python3

import argparse
import re
import sys

from collections import defaultdict
from traceback import print_exc

from digest import digest

GREP_LINE_PATTERN = re.compile(r"^[^\w/]*([^:]+):(\d+):", re.VERBOSE)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-A",
        "--after",
        type=int,
        metavar="NUM",
        help="Collect NUM lines after match, overrides --context",
    )
    parser.add_argument(
        "-B",
        "--before",
        type=int,
        metavar="NUM",
        help="Collect NUM lines before match, overrides --context",
    )
    parser.add_argument(
        "-C",
        "--context",
        type=int,
        metavar="NUM",
        default=3,
        help="Collect NUM lines before and after match",
    )
    return parser.parse_args()


def grep_matches_from_input(input_file):
    for line in input_file:
        grep_match = GREP_LINE_PATTERN.match(line)

        if not grep_match:
            continue

        file_path, line_number = grep_match.groups()
        line_number = int(line_number)

        yield file_path, line_number


def lines_by_path_from_grep_matches(grep_matches, before, after):
    lines_by_path = defaultdict(set)

    for file_path, base_line_number in grep_matches:
        for line_number in range(
            max(base_line_number - before, 1),
            base_line_number + after + 1,
        ):
            lines_by_path[file_path].add(line_number)

    return [
        (file_path, sorted(lines))
        for file_path, lines in sorted(lines_by_path.items())
    ]


def consecutive_ranges(numbers):
    group = []

    for number in numbers:
        if len(group) == 0 or number == group[-1] + 1:
            group.append(number)
        else:
            yield group[0], group[-1]
            group = [number]

    if len(group) > 0:
        yield group[0], group[-1]


def print_hunk_header(file_path, first_line, last_line, hash):
    lines = last_line - first_line + 1
    header_hash = digest([str(i) for i in [file_path, first_line, lines, hash]])
    print(f"@@@ {file_path} {first_line},{lines} {hash} {header_hash} @@@")


def main():
    args = parse_args()
    before = args.before or args.context
    after = args.after or args.context

    grep_matches = grep_matches_from_input(sys.stdin)
    lines_by_path = lines_by_path_from_grep_matches(grep_matches, before, after)

    for file_path, line_number in lines_by_path:
        try:
            with open(file_path) as opened_file:
                file_lines = list(opened_file)
            hash = digest(file_lines)
        except IOError:
            print(f"Cant read {file_path}", file=sys.stderr)
            print_exc()
            continue

        for first, last in consecutive_ranges(line_number):
            last = min(last, len(file_lines))
            print_hunk_header(file_path, first, last, hash)
            hunk_file_lines = file_lines[first - 1 : last]

            for line in hunk_file_lines:
                print(line.rstrip("\n"))


if __name__ == "__main__":
    main()
