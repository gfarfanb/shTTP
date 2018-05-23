#!/usr/bin/env bash
#  Tests for 'api.sh' internal functions.
set -euo pipefail
IFS=$'\n\t'

# ---------- Set-up ----------

. ../api.sh
. ./base_test.sh


# ---------- Tests ----------

#  -test Script clean-up
echo '{}' > ws/cleanable_config.json.tmp

_cleanup

assertFalse "Workspace file is currently exists" "-f ws/cleanable_config.json.tmp"


#  Tests results
results


# ---------- Clean-up ----------

rm -rf output
rm -rf ws
