#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run helmfilenv
  assert_failure
  assert_line 0 "$(helmfilenv---version)"
}

@test "invalid command" {
  run helmfilenv does-not-exist
  assert_failure
  assert_output "helmfilenv: no such command \`does-not-exist'"
}

@test "default HELMFILENV_ROOT" {
  HELMFILENV_ROOT="" HOME=/home/mislav run helmfilenv root
  assert_success
  assert_output "/home/mislav/.helmfilenv"
}

@test "inherited HELMFILENV_ROOT" {
  HELMFILENV_ROOT=/opt/helmfilenv run helmfilenv root
  assert_success
  assert_output "/opt/helmfilenv"
}
