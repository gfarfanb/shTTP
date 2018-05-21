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
if ! [ -d ws/config.json ]; then 
    echo "{}" > ws/config.json
fi


# ---------- External functions ----------



# ---------- Internal functions ----------

#  Cleanup and error catching function.
_cleanup() {
    if [ -d ws ]; then
        find "ws" -name "*.json.tmp" -type f
    	rm -rf *.json.tmp
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

    
fi
