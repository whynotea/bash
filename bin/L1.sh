#!/bin/bash
#==============================================================================
# Global constants
#==============================================================================
# A list of useful constants
bin_name=$(basename "$0")
bin_dir=$(dirname "$0")
SCRIPT_PATH="$bin_dir/../scripts/${bin_name,,}"
#------------------------------------------------------------------------------

#==============================================================================
# Sourced Functions
#==============================================================================
# Try to avoid sourcing other libraries from within a library.
# shellcheck source=../lib/colours.sh
source "$BOOTSTRAP_BASH/lib/colours.sh"
#------------------------------------------------------------------------------

#==============================================================================
# Library Functions
#==============================================================================
function whynotea_script {
  #============================================================================
  # Default values
  #============================================================================
  local status=0 #Explicitly set exit status. Avoid using last commands. 
  local IFS=$' \t\n' 

  local verbose=false #Assume verbose output. 
  #----------------------------------------------------------------------------

  #============================================================================
  # Usage 
  #============================================================================
  Usage()
  {
    IFS=$'\t' read -r -d '%' output <<-EOF
		$bin_name
		---
		usage: $bin_name [options] <command> [<args>]

		Description: 
		An accessor script to conveniently call any ${bin_name} scripts

		Options:
		 [-h] - print this usage statement
		 [-v] - print more verbose output

		Command:
		EOF
    echo "$output" >&2
    for f in $(find "$SCRIPT_PATH" -maxdepth 1 -type f,l -executable | sort) ;
    do
      "$f" "-h"
    done
  }
  #----------------------------------------------------------------------------

  #============================================================================
  # Get Options
  #============================================================================
  local OPTIND # Needed to call getopts multiple times within a script
  while getopts ":hv" opt; do
    case $opt in
      h) 
        Usage 
        exit 1
        ;;
      v) 
        verbose=true
        ;;
      \?)
        echo "Invalid option: -$OPTARG." >&2
        Usage
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
     esac
  done
  shift "$((OPTIND-1))"
  #----------------------------------------------------------------------------

  #============================================================================
  # Function Main
  #============================================================================
  if [ "$#" -ge 1 ] ; then
    script=$SCRIPT_PATH/$1
    shift
    if [[ $verbose == true ]]; then
      echo "$script $*"
    fi
    "$script" "$@"
  else
    whynotea_script -h
  fi
  return $status
  #----------------------------------------------------------------------------
}
whynotea_script "$@"
#------------------------------------------------------------------------------
