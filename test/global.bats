#!/usr/bin/env bats

load test_helper

@test "default" {
  run helmfilenv-global
  assert_success
  assert_output "system"
}

@test "read HELMFILENV_ROOT/version" {
  mkdir -p "$HELMFILENV_ROOT"
  echo "1.2.3" > "$HELMFILENV_ROOT/version"
  run helmfilenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set HELMFILENV_ROOT/version" {
  mkdir -p "$HELMFILENV_ROOT/versions/1.2.3/bin"
  run helmfilenv-global "1.2.3"
  assert_success
  run helmfilenv-global
  assert_success "1.2.3"
}

@test "fail setting invalid HELMFILENV_ROOT/version" {
  mkdir -p "$HELMFILENV_ROOT"
  run helmfilenv-global "1.2.3"
  assert_failure "helmfilenv: version \`1.2.3' is not installed"
}
