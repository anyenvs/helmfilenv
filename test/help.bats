#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run helmfilenv-help
  assert_success
  assert_line "Usage: helmfilenv <command> [<args>]"
  assert_line "Some useful helmfilenv commands are:"
}

@test "invalid command" {
  run helmfilenv-help hello
  assert_failure "helmfilenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${HELMFILENV_TEST_DIR}/bin"
  cat > "${HELMFILENV_TEST_DIR}/bin/helmfilenv-hello" <<SH
#!shebang
# Usage: helmfilenv hello <world>
# Summary: Says "hello" to you, from helmfilenv
# This command is useful for saying hello.
echo hello
SH

  run helmfilenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfilenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${HELMFILENV_TEST_DIR}/bin"
  cat > "${HELMFILENV_TEST_DIR}/bin/helmfilenv-hello" <<SH
#!shebang
# Usage: helmfilenv hello <world>
# Summary: Says "hello" to you, from helmfilenv
echo hello
SH

  run helmfilenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfilenv hello <world>

Says "hello" to you, from helmfilenv
SH
}

@test "extracts only usage" {
  mkdir -p "${HELMFILENV_TEST_DIR}/bin"
  cat > "${HELMFILENV_TEST_DIR}/bin/helmfilenv-hello" <<SH
#!shebang
# Usage: helmfilenv hello <world>
# Summary: Says "hello" to you, from helmfilenv
# This extended help won't be shown.
echo hello
SH

  run helmfilenv-help --usage hello
  assert_success "Usage: helmfilenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${HELMFILENV_TEST_DIR}/bin"
  cat > "${HELMFILENV_TEST_DIR}/bin/helmfilenv-hello" <<SH
#!shebang
# Usage: helmfilenv hello <world>
#        helmfilenv hi [everybody]
#        helmfilenv hola --translate
# Summary: Says "hello" to you, from helmfilenv
# Help text.
echo hello
SH

  run helmfilenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfilenv hello <world>
       helmfilenv hi [everybody]
       helmfilenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${HELMFILENV_TEST_DIR}/bin"
  cat > "${HELMFILENV_TEST_DIR}/bin/helmfilenv-hello" <<SH
#!shebang
# Usage: helmfilenv hello <world>
# Summary: Says "hello" to you, from helmfilenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run helmfilenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfilenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
