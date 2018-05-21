#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly _basename=$( basename "$0" )
readonly _log_file="/tmp/shTTP_${_basename%.*}.`date '+%Y-%m-%d'`.log"
_info() { echo "`date '+%Y-%m-%d %T.%N'` [INFO]    $*" | tee -a "$_log_file" >&2 ; }
_warning() { echo "`date '+%Y-%m-%d %T.%N'` [WARNING] $*" | tee -a "$_log_file" >&2 ; }
_error() { echo "`date '+%Y-%m-%d %T.%N'` [ERROR]   $*" | tee -a "$_log_file" >&2 ; }
_fatal() { echo "`date '+%Y-%m-%d %T.%N'` [FATAL]   $*" | tee -a "$_log_file" >&2 ; exit 1 ; }

_check_dependencies() {
    # 'jq' (command-line JSON processor) is required
    # https://github.com/stedolan/jq
    local _jq_version=$( jq --version )
    if [ -z "$_jq_version" ]; then
        _fatal "'jq' is not installed yet"
    fi
    # Output directory for trace and results files
    if ! [ -d output ]; then 
        mkdir output
	fi
	# Workspace directory for data execution
	if ! [ -d ws ]; then 
        mkdir ws
	fi
}

_cleanup() {
    :
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap _cleanup EXIT

    _check_dependencies
fi
