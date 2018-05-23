#!/usr/bin/env bash
#  Simple HTTP API development environment.
set -euo pipefail
IFS=$'\n\t'

#  Script filename.
readonly _basename=$( basename "$0" )


# ---------- Logging functions ----------

#  Log filename.
readonly _log_file="/tmp/shTTP_${_basename%.*}.`date '+%Y-%m-%d'`.log"

#  Log a message object with the INFO level.
_info() { echo "`date '+%Y-%m-%d %T.%N'` [INFO]    $*" | tee -a "$_log_file" >&2 ; }

#  Log a message object with the WARNING level.
_warning() { echo "`date '+%Y-%m-%d %T.%N'` [WARNING] $*" | tee -a "$_log_file" >&2 ; }

#  Log a message object with the ERROR level.
_error() { echo "`date '+%Y-%m-%d %T.%N'` [ERROR]   $*" | tee -a "$_log_file" >&2 ; }

#  Log a message object with the FATAL level, 
#+ exit execution with 1.
_fatal() { echo "`date '+%Y-%m-%d %T.%N'` [FATAL]   $*" | tee -a "$_log_file" >&2 ; exit 1 ; }


# ---------- Initialization ----------

# 'cURL' is required
readonly _curl_version=$( curl --version )
if [ -z "$_curl_version" ]; then
    _fatal "'curl' is not installed yet"
fi
#  'jq' (command-line JSON processor) is required
#+ https://github.com/stedolan/jq
readonly _jq_version=$( jq --version )
if [ -z "$_jq_version" ]; then
    _fatal "'jq' is not installed yet"
fi
#  Output directory for trace and results files
if ! [ -d output ]; then 
    mkdir output || _fatal "Imposible to create 'output' dorectory"
fi
#  Workspace directory for data execution
if ! [ -d ws ]; then 
    mkdir ws || _fatal "Imposible to create 'ws' dorectory"
fi
#  Config JSON file
if ! [ -f ws/config.json ]; then 
    echo "{}" > ws/config.json
fi


# ---------- External functions ----------

#  Update a JSON file using 'jq'.
#
#  $1 JSON file
#  $2 Change by 'jq'
_update() {
    local _json=${1:-''}
    local _jq=${2:-''}
    jq "$_jq" "$_json" \
		> ws/config.$$.json.tmp \
		&& mv ws/config.$$.json.tmp "$_json"
}

#  Save key-value config to 'config.json'.
#  This function has three different forms:
#  1) Only 'jq' query: _put '.jq'
#  2) Name and 'jq' query: _put 'name' '.jq'
#  3) Name and value: _put 'name' 'value'
#  If 'jq' query is found, the function will
#+ use JSON result to take the value.
#
#  $1 Name of the entry or 'jq' for value
#  $2 Value of the entry or 'jq' for value
_put() {
    local _name="$1"
	local _val=${2:-''}
	if [ -z "$_val" ]; then
	    local _jq="$_name"
	    _name=${_name//[0-9^\[\]]/}
	else
	    local _jq="$_val"
	fi
	_val=$( cat "$OUTPUT.output" | jq "try $_jq catch null" )
	_update "ws/config.json" ". + { \"$_name\": $_val }"
	_info "Saved [$_name] with value [$_val] to workspace config"
}

#  Get value from declared variable, if variable
#+ does not exist value will be obtained from
#+ 'config.json' by key (it can be a 'jq' query).
#  Result will be translated to string
#+ and the quotes will be removed.
_get() {
    local _name="$1"
	local _val=""
	if [[ "$_name" =~ ^[a-zA-Z]*$ ]]; then
	    _val=$( eval "echo \${$_name:-''}" )
	fi
	if [ -n "$_val" ]; then
	    echo $_val
	else
        echo $( jq ".$_name | tostring" ws/config.json ) \
		    | sed -e 's/^"//' -e 's/"$//'
	fi
}

#  Remove key-value from 'config.json' by key
#+ (it can be a 'jq' query).
_remove() {
	local _name="$1"
	_update "ws/config.json" "del(.$1)"
	_info "Removed [$_name] from workspace config"
}


# ---------- Internal functions ----------

#  Cleanup and error catching function.
_cleanup() {
    if [ -d ws ]; then
        rm -rf ws/*.json.tmp
    fi
}


# ---------- Option functions ----------

#  List the names of available functions.
#  All named functions start with '_' 
#+ will be discarded from the list.
_list() {
    declare -a _functions=(
	    $( declare -F )
	)
	for _function in ${_functions[@]}; do
		local _name=$( echo "$_function" | cut -d ' ' -f 3 )
		if ! [[ "$_name" == "_"* ]]; then
		    echo $_name
		fi
	done
}
expr "$*" : ".*--list" > /dev/null && _list \
    && exit 0

#  Clean output files.
_clean() {
    if [ -d output ]; then
        find "output" -name "*" -type f
    	rm -rf output/*
	fi
}
expr "$*" : ".*--clean" > /dev/null && _clean \
    && _info "Cleaning completed" \
    && exit 0


# ---------- Main code ----------

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap _cleanup EXIT

    OUTPUT="output/output.$$"
    echo '{"id":"5s43u-323we"}' > "$OUTPUT.output"
    
    _put '.id'
    _put 'jqId' '.id'
    _put 'rawId' '"4jj43-34mdwe"'
    _put 'idx' 5
    _put 'flag' true
    _put 'null' null
    _put 'object' '{}'
fi
