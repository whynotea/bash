#!/bin/bash
#==============================================================================
# Global constants
#==============================================================================
# A list of useful constants
bin_name=$(basename "$0")
#------------------------------------------------------------------------------

#==============================================================================
# Sourced Functions
#==============================================================================
# Try to avoid sourcing other libraries from within a library.
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
		      An example of an L3 script, copy and edit as required

		      Options:
		       [-h] - print this usage statement
		       [-v] - print more verbose output
		EOF
    echo "$output" >&2
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
  if [[ $verbose == true ]]; then
    echo "Running with verbose output"
  fi
  if [ "$#" -ge 1 ] ; then
    echo "Hello from $bin_name"
  else
    whynotea_script -h
  fi
  return $status
  #----------------------------------------------------------------------------
}
whynotea_script "$@"
#------------------------------------------------------------------------------
