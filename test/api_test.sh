#!/usr/bin/env bash

oneTimeSetUp() {
  . ../api.sh
}


# ---------- Initialization ----------

test_exists_output_dir() {
    if ! [ -d output ]; then
	   fail "Output directory is not found"
	fi
}

test_exists_ws_dir() {
    if ! [ -d ws ]; then
	   fail "Workspace directory is not found"
	fi
}

test_exists_config_json() {
    if ! [ -f ws/config.json ]; then
	   fail "Config JSON is not found"
	fi
}


# ---------- External functions ----------




# ---------- Internal functions ----------

test_cleanup() {
    echo '{}' > ws/cleanable_config.json.tmp
	_cleanup
	if [ -f ws/cleanable_config.json.tmp ]; then
	   fail "Workspace file is currently exists"
	fi
}


# ---------- Option functions ----------

test_list() {
    local _list=$( _list )
    local _found=0
    for _i in ${_list[@]}; do
	   [ "$_i" == "test_list" ] && _found=1	  	
	done
	assertEquals "Function not found" 1 "$_found"
}

test_clean() {
    echo '{}' > output/cleanable_output.json
	_clean
	if [ -f output/cleanable_output.json ]; then
	   fail "Output file is currently exists"
	fi
}

. shunit2
