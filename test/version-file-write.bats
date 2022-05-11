#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILENV_TEST_DIR"
  cd "$HELMFILENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run helmfilenv-version-file-write
  assert_failure "Usage: helmfilenv version-file-write <file> <version>"
  run helmfilenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".helm-version" ]
  run helmfilenv-version-file-write ".helm-version" "1.11.3"
  assert_failure "helmfilenv: version \`1.11.3' is not installed"
  assert [ ! -e ".helm-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${HELMFILENV_ROOT}/versions/1.10.8/bin"
  assert [ ! -e "my-version" ]
  run helmfilenv-version-file-write "${PWD}/my-version" "1.10.8"
  assert_success ""
  assert [ "$(cat my-version)" = "1.10.8" ]
}
