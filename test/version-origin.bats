#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILENV_TEST_DIR"
  cd "$HELMFILENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${HELMFILENV_ROOT}/version" ]
  run helmfilenv-version-origin
  assert_success "${HELMFILENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$HELMFILENV_ROOT"
  touch "${HELMFILENV_ROOT}/version"
  run helmfilenv-version-origin
  assert_success "${HELMFILENV_ROOT}/version"
}

@test "detects HELMFILENV_VERSION" {
  HELMFILENV_VERSION=1 run helmfilenv-version-origin
  assert_success "HELMFILENV_VERSION environment variable"
}

@test "detects local file" {
  echo "system" > .helm-version
  run helmfilenv-version-origin
  assert_success "${PWD}/.helm-version"
}

@test "doesn't inherit HELMFILENV_VERSION_ORIGIN from environment" {
  HELMFILENV_VERSION_ORIGIN=ignored run helmfilenv-version-origin
  assert_success "${HELMFILENV_ROOT}/version"
}
