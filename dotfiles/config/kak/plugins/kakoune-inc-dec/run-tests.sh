#!/bin/sh
cd "${0%/*}"

log() { printf '%s\n' "$*" >&2; }
die() { log "$*"; exit 1; }

run_test() {
    testname=$1
    if [ "$testname" = "" ]; then
        die "Must provide a test name"
    fi

    if ! [ -f "$testname/input.txt" ]; then
        die "$(pwd)/$testname/ does not look like a test"
    fi

    log "Running test $testname..."

    cp "$testname/input.txt" "$testname/actual.txt" ||
        die "Could not stage test data"
    kak -n -ui dummy "$testname/actual.txt" -e "
        set global autoreload yes
        set global autoinfo ''
        set global autocomplete ''
        hook global RuntimeError .+ %{
            echo -debug -- error: %val{hook_param}
            eval -buffer *debug* write -force '$testname/debug.txt'
            quit!
        }
        source 'inc-dec.kak'
        source '$testname/commands.txt'
        eval -buffer '$testname/actual.txt' write -force
        eval -buffer *debug* write -force '$testname/debug.txt'
        quit!
        " || die "Could not run test"

    diff -u "$testname/actual.txt" "$testname/expected.txt"
}

run_all_tests() {
    failures=0
    for testname in tests/*; do
        run_test "$testname" || failures=$((failures + 1))
    done
    if [ "$failures" -gt 0 ]; then
        log "$failures tests failed"
    fi
    return $failures
}

if [ "$#" -eq 0 ]; then
    run_all_tests
else
    "$@"
fi
