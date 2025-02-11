#!/usr/bin/bats

setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'
  source ./gol.sh
}

teardown() {
    : # Look Ma! No cleanup!
}

@test "board should be empty on start" {
  assert [ $(get_length) -eq 0 ]
  assert [ $(get_at 0 0) -eq 0 ]
}

@test "board should contain 1 active cell" {
  set_at 0 0
  assert [ $(get_at 0 0) -eq 1 ]
  assert [ $(get_length) -eq 1 ]
}

@test "board should contain 3 active cells" {
  set_at 0 0
  set_at 0 1
  set_at 1 1
  assert [ $(get_at 0 0) -eq 1 ]
  assert [ $(get_at 0 1) -eq 1 ]
  assert [ $(get_at 1 1) -eq 1 ]
  assert [ $(get_length) -eq 3 ]
}

@test "0,0 should have 3 neighbours" {
  set_at 0 0
  set_at 1 0 
  set_at 0 1
  set_at 1 1
  assert [ $(get_neighbours 0 0) -eq 3 ]
  assert [ $(get_neighbours 1 0) -eq 3 ]
  assert [ $(get_neighbours 1 1) -eq 3 ]
}

@test "0,0 should have 0 neighbours" {
  set_at 0 0
  assert [ $(get_neighbours 0 0) -eq 0 ]
}
