#!/usr/bin/env bash
#  Tests for 'api.sh' external functions.
set -euo pipefail
IFS=$'\n\t'

# ---------- Set-up ----------

. ../api.sh
. ./base_test.sh

OUTPUT="output/output.$$"
echo '{"id":"5s43u-323we"}' > "$OUTPUT.output"


# ---------- Tests ----------

#  -test Put key-value config
_put '.id'
_id=$( cat "ws/config.json" | jq ".id" )
assertEquals "'id' not found" "\"5s43u-323we\"" "$_id"

_put 'jqId' '.id'
_jqId=$( cat "ws/config.json" | jq ".jqId" )
assertEquals "'jqId' not found" "\"5s43u-323we\"" "$_jqId"

_put 'rawId' '"4jj43-34mdwe"'
_rawId=$( cat "ws/config.json" | jq ".rawId" )
assertEquals "'rawId' not found" "\"4jj43-34mdwe\"" "$_rawId"

_put 'idx' 5
_idx=$( cat "ws/config.json" | jq ".idx" )
assertEquals "'idx' not found" "5" "$_idx"

_put 'flag' true
_flag=$( cat "ws/config.json" | jq ".flag" )
assertEquals "'flag' not found" "true" "$_flag"

_put 'null' null
_null=$( cat "ws/config.json" | jq ".null" )
assertEquals "'null' not found" "null" "$_null"

_put 'object' '{}'
_object=$( cat "ws/config.json" | jq ".object" )
assertEquals "'object' not found" "{}" "$_object"


#  -test Get key-value config
_id=$( _get id )
assertEquals "'id' not found" "5s43u-323we" "$_id"

_jqId=$( _get jqId )
assertEquals "'jqId' not found" "5s43u-323we" "$_jqId"

_rawId=$( _get rawId )
assertEquals "'rawId' not found" "4jj43-34mdwe" "$_rawId"

_idx=$( _get idx )
assertEquals "'idx' not found" "5" "$_idx"

_flag=$( _get flag )
assertEquals "'flag' not found" "true" "$_flag"

_null=$( _get null )
assertEquals "'null' not found" "null" "$_null"

_object=$( _get object )
assertEquals "'object' not found" "{}" "$_object"

_unknown=$( _get unknown )
assertEquals "'unknown' was found" "null" "$_unknown"


#  -test Remove key-value config
_remove id
_id=$( _get id )
assertEquals "'id' was found" "null" "$_id"

_remove jqId
_jqId=$( _get jqId )
assertEquals "'jqId' was found" "null" "$_jqId"

_remove rawId
_rawId=$( _get rawId )
assertEquals "'rawId' was found" "null" "$_rawId"

_remove idx
_idx=$( _get idx )
assertEquals "'idx' was found" "null" "$_idx"

_remove flag
_flag=$( _get flag )
assertEquals "'flag' was found" "null" "$_flag"

_remove null
_null=$( _get null )
assertEquals "'null' was found" "null" "$_null"

_remove object
_object=$( _get object )
assertEquals "'object' was found" "null" "$_object"

_remove unknown
_unknown=$( _get unknown )
assertEquals "'unknown' was found" "null" "$_unknown"


#  Tests results
results


# ---------- Clean-up ----------

rm -rf output
rm -rf ws
