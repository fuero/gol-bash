#!/usr/bin/bats

setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'
  source ./gol.sh
}

teardown() {
    : # Look Ma! No cleanup!
}

@test "should be dead with 1 neighbour" {
  assert [ $(is_alive 1) -eq 0 ]
}

@test "should be alive with 2 neighbours" {
  assert [ $(is_alive 2) -eq 1 ]
}

@test "should be alive with 3 neighbours" {
  assert [ $(is_alive 3) -eq 1 ]
}

@test "should be dead with 4 neighbours" {
  assert [ $(is_alive 4) -eq 0 ]
}

@test "should be revived with 3 neighbours" {
  assert [ $(is_alive 3 0) -eq 1 ]
}
