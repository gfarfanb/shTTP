#!/usr/bin/env bash
#  Tests for 'api.sh' option functions.
set -euo pipefail
IFS=$'\n\t'

# ---------- Set-up ----------

. ../api.sh
. ./base_test.sh


# ---------- Tests ----------

#  -test List available commands
declared_command() {
    :
}

_commands=$( _list )
_found=0

for _i in ${_commands[@]}; do
    [ "$_i" = "declared_command" ] && _found=1
done

assertEquals "Command not found" 1 "$_found"


#  -test Clean option
echo '{}' > output/cleanable_output.json

_clean

assertFalse "Output file is currently exists" "-f output/cleanable_output.json"


#  Tests results
results


# ---------- Clean-up ----------

rm -rf output
rm -rf ws
