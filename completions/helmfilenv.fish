function __fish_helmfilenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'helmfilenv' ]
    return 0
  end
  return 1
end

function __fish_helmfilenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c helmfilenv -n '__fish_helmfilenv_needs_command' -a '(helmfilenv commands)'
for cmd in (helmfilenv commands)
  complete -f -c helmfilenv -n "__fish_helmfilenv_using_command $cmd" -a \
    "(helmfilenv completions (commandline -opc)[2..-1])"
end
