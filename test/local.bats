#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${HELMFILENV_TEST_DIR}/myproject"
  cd "${HELMFILENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.helm-version" ]
  run helmfilenv-local
  assert_failure "helmfilenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .helm-version
  run helmfilenv-local
  assert_success "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .helm-version
  mkdir -p "subdir" && cd "subdir"
  run helmfilenv-local
  assert_success "1.2.3"
}

@test "ignores HELMFILENV_DIR" {
  echo "1.2.3" > .helm-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.helm-version"
  HELMFILENV_DIR="$HOME" run helmfilenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${HELMFILENV_ROOT}/versions/1.2.3/bin"
  run helmfilenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helm-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .helm-version
  mkdir -p "${HELMFILENV_ROOT}/versions/1.2.3/bin"
  run helmfilenv-local
  assert_success "1.0-pre"
  run helmfilenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helm-version)" = "1.2.3" ]
}

@test "unsets local version" {
  touch .helm-version
  run helmfilenv-local --unset
  assert_success ""
  assert [ ! -e .helm-version ]
}
