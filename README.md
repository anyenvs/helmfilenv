# helmfilenv

[Helmfile](https://helm.sh) version manager.

Most of the codes are taken from below tools:

* [rbenv](https://github.com/rbenv/rbenv)
* [tfenv](https://github.com/Zordrak/tfenv)

## Installation

1. Check out helmfilenv into any path (here is `${HOME}/.helmfilenv`)

  ```sh
  $ git clone https://github.com/yuya-takeyama/helmfilenv.git ~/.helmfilenv
  ```

2. Add `~/.helmfilenv/bin` to your `$PATH` any way you like

  ```sh
  $ echo 'export PATH="$HOME/.helmfilenv/bin:$PATH"' >> ~/.bash_profile
  ```

## Usage

```
Usage: helmfilenv <command> [<args>]

Some useful helmfilenv commands are:
   local       Set or show the local application-specific Helm version
   global      Set or show the global Helm version
   install     Install the specified version of Helm
   uninstall   Uninstall the specified version of Helm
   version     Show the current Helm version and its origin
   versions    List all Helm versions available to helmfilenv

See `helmfilenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/yuya-takeyama/helmfilenv#readme
```

## License

* helmfilenv
  * The MIT License
* [rbenv](https://github.com/rbenv/rbenv)
  * The MIT License
* [tfenv](https://github.com/Zordrak/tfenv)
  * The MIT License
