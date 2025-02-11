#!/usr/bin/bats

setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'
  source ./gol.sh
}

teardown() {
    : # Look Ma! No cleanup!
}

@test "Sample game finishes after five ticks" {
  assert [ $(get_length) -eq 0 ]
  assert [ $(get_at 0 0) -eq 0 ]

  # xx
  # xx
  #  x

  set_at 0 0
  set_at 1 0
  set_at 0 1
  set_at 1 1
  set_at 2 1
 
  tick

  assert [ $(get_at 0 0) -eq 1 ]
  assert [ $(get_at 0 1) -eq 1 ]
  assert [ $(get_at 2 0) -eq 1 ]
  assert [ $(get_at 2 1) -eq 1 ]

  assert [ $(get_length) -eq 5 ]

  tick
  
  assert [ $(get_length) -eq 3 ]
  
  tick

  assert [ $(get_length) -eq 2 ]
  
  assert [ $(get_at 1 2) -eq 1 ]
  assert [ $(get_at 1 1) -eq 1 ]

  tick

  assert [ $(get_length) -eq 0 ]
}
