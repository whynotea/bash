#!/bin/bash

function current_branch() {
  git rev-parse --abbrev-ref HEAD
}

function getReleaseNotes() {
  local plugin="$1"
  local key="$2"
  curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $key" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/trevorgetty/$plugin/releases"
}

function branch_is_in_local() {
    local branch="$1"
    local existed_in_local=
    existed_in_local=$(git branch --list "${branch}")

    if [[ -z ${existed_in_local} ]]; then
        echo 0
    else
        echo 1
    fi
}

function branch_is_in_remote() {
    local branch="$1"
    local existed_in_remote=
    existed_in_remote=$(git ls-remote --heads origin "${branch}")

    if [[ -z ${existed_in_remote} ]]; then
        echo 0
    else
        echo 1
    fi
}

function tag_is_in_local() {
    local tag="$1"
    local existed_in_local=
    existed_in_local=$(git tag -l "${tag}")

    if [[ -z ${existed_in_local} ]]; then
        echo 0
    else
        echo 1
    fi
}

function tag_is_in_remote() {
    local tag="$1"
    local existed_in_remote=
    existed_in_remote=$(git ls-remote --tags origin "${tag}")

    if [[ -z ${existed_in_remote} ]]; then
        echo 0
    else
        echo 1
    fi
}

function confirm() {
  # Message to display before confirmation
  local message="$1"
  
  # Read user input with case-insensitive comparison
  read -r -p "$message (Y/n) " response < /dev/tty
  response=${response:-y}  # Default to y
  response=${response,,}  # Convert to lowercase

  # Check user response
  if [[ "$response" != "y" ]]; then
    echo "Aborting..."
    return 1  # Indicate user declined
  fi
  
  return 0  # Indicate user agreed
}

function deleteTag() {
  local tag=$1
  if [[ $(tag_is_in_local "$tag") == 1 ]]; then 
    echo "Found local $tag"
    git tag -d "$tag"
  fi
  if [[ $(tag_is_in_remote "$tag") == 1 ]]; then 
    echo "Found remote $tag"
    git push --delete origin "$tag"
  fi
}

function gitClean() {
  git reset --hard                                 
  git submodule sync --recursive                   
  git submodule update --init --force --recursive  
  git clean -ffdx                                  
  git submodule foreach --recursive git clean -ffdx
}
