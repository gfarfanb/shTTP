#!/usr/bin/env bash
#  Common functions for unit tests.
set -euo pipefail
IFS=$'\n\t'

_failures=0
_assertions=0

_fail() {
    echo ">>>   [FAILED]   $*"
    _failures=$(( _failures+1 ))
}

fail() {
    _fail "$*"
    _assertions=$(( _assertions+1 ))
}

assertTrue() {
    local _message=${1:-''}
    local _condition=${2:-''}
    local _ok=1
    eval "if ! [ $_condition ]; then _ok=0 ; fi"
    if [ $_ok = 0 ]; then
        _fail "[ $_condition ]: $_message"
    fi
    _assertions=$(( _assertions+1 ))
}

assertFalse() {
    local _message=${1:-''}
    local _condition=${2:-''}
    local _ok=1
    eval "if [ $_condition ]; then _ok=0 ; fi"
    if [ $_ok = 0 ]; then
        _fail "! [ $_condition ]: $_message"
    fi
    _assertions=$(( _assertions+1 ))
}

assertEquals() {
    local _message=${1:-''}
    local _expected=${2:-''}
    local _input=${3:-''}
    local _ok=1
    if [ "$_expected" != "$_input" ]; then
        _fail "[ "$_expected" = "$_input" ]: $_message"
    fi
    _assertions=$(( _assertions+1 ))
}

assertNotEquals() {
    local _message=${1:-''}
    local _expected=${2:-''}
    local _input=${3:-''}
    local _ok=1
    if [ "$_expected" = "$_input" ]; then
        _fail "[ "$_expected" != "$_input" ]: $_message"
    fi
    _assertions=$(( _assertions+1 ))
}

results() {
    if [ $_failures = 0 ]; then
        echo "$( basename "$0" ): [PASSED] - [$_assertions] of [$_assertions] assertions passed"
    else
        echo "$( basename "$0" ): [FAILED] - [$_failures] of [$_assertions] assertions failed"
    fi
}
