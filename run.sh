#!/bin/bash
set -euo pipefail
source gol.sh
set_at 0 0
set_at 1 0
set_at 0 1
set_at 1 1
set_at 2 1

while [[ "$(get_length)" -gt 0 ]]
do
  print_board 5
#  dump_board BOARD
  tick
  #read -rp "Press Enter to continue" </dev/tty
done
