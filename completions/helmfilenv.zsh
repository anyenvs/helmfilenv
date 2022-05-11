if [[ ! -o interactive ]]; then
    return
fi

compctl -K _helmfilenv helmfilenv

_helmfilenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(helmfilenv commands)"
  else
    completions="$(helmfilenv completions ${words[2,-2]})"
  fi

  reply=(${(ps:\n:)completions})
}
