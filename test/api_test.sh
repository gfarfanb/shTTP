#!/usr/bin/env bash

oneTimeSetUp() {
    . ../api.sh    
}

oneTimeTearDown() {
    rm -rf output
    rm -rf ws
}


# ---------- Initialization ----------

testExistsOutputDir() {
    if ! [ -d output ]; then
        fail "Output directory is not found"
    fi
}

testExistsWsDir() {
    if ! [ -d ws ]; then
        fail "Workspace directory is not found"
    fi
}

testExistsConfigJson() {
    if ! [ -f ws/config.json ]; then
        fail "Config JSON is not found"
    fi
}


# ---------- External functions ----------

testPut() {
    OUTPUT="output/output.$$"
    echo '{"id":"5s43u-323we"}' > "$OUTPUT.output"

    _put id '.id'
    _put name 'test_put'

    local _id=$( cat "$OUTPUT.output" | jq ".id" )
    local _name=$( cat "$OUTPUT.output" | jq ".name" )

    assertEquals "ID not put on config" "\"5s43u-323we\"" "$_id"
    assertEquals "Name not put on config" "\"test_put\"" "$_name"
}

testGet() {
    OUTPUT="output/output.$$"
    echo '{"id":"5s43u-323we"}' > "$OUTPUT.output"
    
    local _id=$( _get id )
    assertEquals "ID does not exist" "\"5s43u-323we\"" "$_id":
}

testRemove() {
    OUTPUT="output/output.$$"
    echo '{"id":"5s43u-323we"}' > "$OUTPUT.output"
    
    _remove id
    
    local _id=$( cat "$OUTPUT.output" | jq ".id" )
    assertEquals "ID must not exist" "\"null\"" "$_id":
}


# ---------- Internal functions ----------

testCleanup() {
    echo '{}' > ws/cleanable_config.json.tmp
	_cleanup
	if [ -f ws/cleanable_config.json.tmp ]; then
	   fail "Workspace file is currently exists"
	fi
}


# ---------- Option functions ----------

testList() {
    local _list=$( _list )
    local _found=0
    for _i in ${_list[@]}; do
	   [ "$_i" == "test_list" ] && _found=1	  	
	done
	assertEquals "Function not found" 1 "$_found"
}

testClean() {
    echo '{}' > output/cleanable_output.json
	_clean
	if [ -f output/cleanable_output.json ]; then
	   fail "Output file is currently exists"
	fi
}

. shunit2
