#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILENV_TEST_DIR"
  cd "$HELMFILENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMFILENV_ROOT}/versions" ]
  run helmfilenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  HELMFILENV_VERSION=system run helmfilenv-version-name
  assert_success "system"
}

@test "HELMFILENV_VERSION has precedence over local" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > ".helm-version" <<<"1.10.8"
  run helmfilenv-version-name
  assert_success "1.10.8"

  HELMFILENV_VERSION=1.11.3 run helmfilenv-version-name
  assert_success "1.11.3"
}

@test "local file has precedence over global" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > "${HELMFILENV_ROOT}/version" <<<"1.10.8"
  run helmfilenv-version-name
  assert_success "1.10.8"

  cat > ".helm-version" <<<"1.11.3"
  run helmfilenv-version-name
  assert_success "1.11.3"
}

@test "missing version" {
  HELMFILENV_VERSION=1.2 run helmfilenv-version-name
  assert_failure "helmfilenv: version \`1.2' is not installed (set by HELMFILENV_VERSION environment variable)"
}
