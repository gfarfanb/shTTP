#!/usr/bin/env bash
#  Tests for 'api.sh' initialization.
set -euo pipefail
IFS=$'\n\t'

# ---------- Set-up ----------

. ../api.sh
. ./base_test.sh


# ---------- Tests ----------

#  -test Output directory exists
assertTrue "Output directory is not found" "-d output"


#  -test Workspace directory exists
assertTrue "Workspace directory is not found" "-d ws"


#  -test Config file exists
assertTrue "Config JSON is not found" "-f ws/config.json"


#  Tests results
results


# ---------- Clean-up ----------

rm -rf output
rm -rf ws
