#!/usr/bin/env python3
import argparse
import re
import subprocess
import sys
import io

from collections import namedtuple, defaultdict

from digest import digest


class BadHash(Exception):
    pass


class HeaderModified(Exception):
    def __init__(self, input_line):
        self.input_line = input_line


HUNK_HEADER_RE = re.compile(
    r"""
    ^ @@@ \s
    (?P<path> .+ ) \s
    (?P<first_line> \d+ ) , (?P<line_count> \d+ ) \s
    (?P<hash> \S+ ) \s
    (?P<header_hash> \S+ ) \s
    @@@ $
    """,
    re.VERBOSE,
)


InputHunk = namedtuple(
    "InputHunk",
    "input_line path first_line line_count hash header_hash contents",
)
File = namedtuple("File", "path hash ordered_hunks")
Hunk = namedtuple(
    "Hunk", "input_line first_line line_count header_hash contents"
)


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--dry-run",
        action="store_true",
    )

    return parser.parse_args()


def read_input_hunks(lines):
    hunks = []

    for i, line in enumerate(lines):
        hunk_header_match = HUNK_HEADER_RE.match(line)

        if hunk_header_match is not None:
            hunk = InputHunk(
                input_line=i + 1,
                path=hunk_header_match.group("path"),
                first_line=int(hunk_header_match.group("first_line")),
                line_count=int(hunk_header_match.group("line_count")),
                hash=hunk_header_match.group("hash"),
                header_hash=hunk_header_match.group("header_hash"),
                contents=[],
            )

            hunks.append(hunk)

        else:
            if len(hunks) == 0:
                raise Exception("Bad input: first line must be hunk header")
            hunks[-1].contents.append(line)

    return hunks


def group_input_hunks_by_file(input_hunks):
    files = []

    hunks_by_file = defaultdict(list)
    for input_hunk in input_hunks:
        hunks_by_file[input_hunk.path].append(input_hunk)

    for path, input_hunks in hunks_by_file.items():
        if any(
            input_hunk.hash != input_hunks[0].hash for input_hunk in input_hunks
        ):
            raise Exception(f"Bad input: different hashes for {path}")

        ordered_hunks = sorted(
            (
                Hunk(
                    input_line=input_hunk.input_line,
                    first_line=input_hunk.first_line,
                    line_count=input_hunk.line_count,
                    header_hash=input_hunk.header_hash,
                    contents=input_hunk.contents,
                )
                for input_hunk in input_hunks
            ),
            key=lambda hunk: hunk.first_line,
        )

        files.append(
            File(
                path=path,
                hash=input_hunks[0].hash,
                ordered_hunks=ordered_hunks,
            )
        )

    return files


def apply_file_hunks(file):
    for hunk in file.ordered_hunks:
        computed_header_hash = digest(
            [
                str(i)
                for i in [
                    file.path,
                    hunk.first_line,
                    hunk.line_count,
                    file.hash,
                ]
            ]
        )
        if computed_header_hash != hunk.header_hash:
            raise HeaderModified(hunk.input_line)

    with open(file.path, encoding="utf8") as opened_file:
        file_lines = list(opened_file)

    hash = digest(file_lines)
    if hash != file.hash:
        raise BadHash()

    offset = 0
    for hunk in file.ordered_hunks:
        start_index = hunk.first_line - 1 + offset
        file_lines[start_index : start_index + hunk.line_count] = hunk.contents
        offset += len(hunk.contents) - hunk.line_count

    return "".join(file_lines)


def show_diff(file, new_contents):
    subprocess.run(
        ["diff", "-U3", file.path, "-"],
        input=new_contents.encode("utf8"),
    )


def write_back(file, new_contents):
    with open(file.path, "w", encoding="utf8") as opened_file:
        opened_file.write(new_contents)


def main():
    args = parse_args()

    try:
        input_hunks = read_input_hunks(sys.stdin)
        files = group_input_hunks_by_file(input_hunks)
    except Exception as error:
        print(f"Error while reading input: {error}")
        sys.exit(1)

    successful_files = 0
    for file in files:
        try:
            new_contents = apply_file_hunks(file)
            successful_files += 1

            if args.dry_run:
                show_diff(file, new_contents)
            else:
                write_back(file, new_contents)
                print(f"{file.path}: OK")

        except HeaderModified as e:
            print(f"{file.path}: header modified (line {e.input_line})")

        except BadHash:
            print(f"{file.path}: modified on disk")

        except IOError as error:
            print(f"{file.path}: {error}")

    action = "can be applied" if args.dry_run else "applied"
    print(f"Changes on {successful_files} out of {len(files)} files {action}")

    if successful_files < len(files):
        sys.exit(1)


if __name__ == "__main__":
    main()
