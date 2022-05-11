#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILENV_TEST_DIR"
  cd "$HELMFILENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  echo "system" > "$1"
}

@test "detects global 'version' file" {
  create_file "${HELMFILENV_ROOT}/version"
  run helmfilenv-version-file
  assert_success "${HELMFILENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${HELMFILENV_ROOT}/version" ]
  assert [ ! -e ".helm-version" ]
  run helmfilenv-version-file
  assert_success "${HELMFILENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".helm-version"
  run helmfilenv-version-file
  assert_success "${HELMFILENV_TEST_DIR}/.helm-version"
}

@test "in parent directory" {
  create_file ".helm-version"
  mkdir -p project
  cd project
  run helmfilenv-version-file
  assert_success "${HELMFILENV_TEST_DIR}/.helm-version"
}

@test "topmost file has precedence" {
  create_file ".helm-version"
  create_file "project/.helm-version"
  cd project
  run helmfilenv-version-file
  assert_success "${HELMFILENV_TEST_DIR}/project/.helm-version"
}

@test "HELMFILENV_DIR has precedence over PWD" {
  create_file "widget/.helm-version"
  create_file "project/.helm-version"
  cd project
  HELMFILENV_DIR="${HELMFILENV_TEST_DIR}/widget" run helmfilenv-version-file
  assert_success "${HELMFILENV_TEST_DIR}/widget/.helm-version"
}

@test "PWD is searched if HELMFILENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.helm-version"
  cd project
  HELMFILENV_DIR="${HELMFILENV_TEST_DIR}/widget/blank" run helmfilenv-version-file
  assert_success "${HELMFILENV_TEST_DIR}/project/.helm-version"
}

@test "finds version file in target directory" {
  create_file "project/.helm-version"
  run helmfilenv-version-file "${PWD}/project"
  assert_success "${HELMFILENV_TEST_DIR}/project/.helm-version"
}

@test "fails when no version file in target directory" {
  run helmfilenv-version-file "$PWD"
  assert_failure ""
}
