#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILENV_TEST_DIR"
  cd "$HELMFILENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMFILENV_ROOT}/versions" ]
  run helmfilenv-version
  assert_success "system (set by ${HELMFILENV_ROOT}/version)"
}

@test "set by HELMFILENV_VERSION" {
  create_version "1.11.3"
  HELMFILENV_VERSION=1.11.3 run helmfilenv-version
  assert_success "1.11.3 (set by HELMFILENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.11.3"
  cat > ".helm-version" <<<"1.11.3"
  run helmfilenv-version
  assert_success "1.11.3 (set by ${PWD}/.helm-version)"
}

@test "set by global file" {
  create_version "1.11.3"
  cat > "${HELMFILENV_ROOT}/version" <<<"1.11.3"
  run helmfilenv-version
  assert_success "1.11.3 (set by ${HELMFILENV_ROOT}/version)"
}
