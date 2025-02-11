#!/bin/bash
set -euo pipefail

declare -Ax BOARD=()

function is_alive() {
  local neighbours="${1:-0}" state="${2:-1}"

  if [[ "${neighbours}" -ge 2 && "${neighbours}" -le 3 && "${state}" -eq 1 ]] \
    || [[ "${state}" -eq 0 && "${neighbours}" == 3 ]]
  then
    echo -ne '1'
  else
    echo -ne '0'
  fi
}

function set_at() {
  local x="${1:-0}" y="${2:-0}" state="${3:-1}"
  # https://stackoverflow.com/questions/68167187/how-to-use-a-bash-variable-reference-to-an-associative-array-in-a-bash-function
  declare -Ag "${4:-BOARD}"
  local -n board_ref="${4:-BOARD}"
  for ((i=-1; i<=1; i++))
  do
    for ((j=-1; j<=1; j++))
    do
      local index=$((x+i)),$((y+j))
      # Set the given cell
      if [[ ${i} -eq 0 && ${j} -eq 0 ]]
      then
        # shellcheck disable=SC2004
        board_ref[${index}]="${state}"
      fi
      # If given a "1" to set, set all unset surrounding cells to "0" to
      # allow resurrection
      if [[ ! -v board_ref[${index}] && "${state}" -eq 1 ]]
      then
        # shellcheck disable=SC2004
        board_ref[${index}]=0
      fi
    done
  done
}

function get_at() {
  local x="${1:-0}" y="${2:-0}"
  declare -Ag "${3:-BOARD}"
  # shellcheck disable=SC2178
  local -n board="${3:-BOARD}"
  printf "%d" "${board["${x},${y}"]:-0}"
}

function get_neighbours() {
  local neighbours=0 x="${1:-0}" y="${2:-0}"
  declare -Ag "${3:-BOARD}"
  # shellcheck disable=SC2178
  local -n board="${3:-BOARD}"
  for ((i=-1;i<=1;i++))
  do
    for ((j=-1;j<=1;j++))
    do
      if [[ ${i} -eq 0 && ${j} -eq 0 ]]
      then
        continue
      fi
      local index="$((x+i)),$((y+j))"
      if [[ -v board[${index}] ]] && [[ ${board[${index}]} -eq 1 ]]
      then
        neighbours=$((neighbours + 1))
      fi
    done
  done
  printf "%d" "${neighbours}"
}

function tick() {
  declare -Ag BOARD
  # shellcheck disable=SC2034
  declare -A NEXT_BOARD=()
  local -n board=BOARD
  for i in "${!board[@]}"
  do
    # https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
    # x,y
    mapfile -td "," fields < <(printf "%s\0" "${i}")
    local x="${fields[0]}" y="${fields[1]}"
    local state="$(get_at "${x}" "${y}")"
    unset fields
    set_at "${x}" "${y}" "$(is_alive $(get_neighbours "${x}" "${y}") "${state}")" NEXT_BOARD
  done
  unset BOARD board
  declare -Ag BOARD
  copy_array NEXT_BOARD BOARD
}

function get_length() {
  declare -Ag "${1:-BOARD}"
  local -n board="${1:-BOARD}"
  local cnt=0
  for i in "${!board[@]}"
  do
    if [[ ${board["${i}"]} -eq 1 ]]
    then
      cnt=$((cnt+1))
    fi
  done
  set +u
  printf "%d" "${cnt}"
  set -u
}

function copy_array() {
  declare -Ag "${1}"
  declare -Ag "${2}"
  local -n from="${1}" to="${2}"
  for i in "${!from[@]}"
  do
    # shellcheck disable=SC2004,SC2034
    to[${i}]=${from[${i}]}
  done
}

function dump_board() {
  declare -Ag "${1}"
  declare -p "${1}"
}

function print_board() {
  local n="${1:-5}"
  local out=""
  for ((i=-n; i<=n; i++))
  do
    for ((j=-n; j<=n; j++))
    do
      if [[ $(get_at "${i}" "${j}" "${2:-BOARD}") -eq 1 ]]
      then
        out="${out}x"
      else
        out="${out} "
      fi
    done
    out="${out}\n"
  done
  echo -ne "${out}"
}
