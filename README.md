# Automatic Repo Tagging GitHub Action

This GitHub Action automatically tags master with the version in a file. Right now, only the version in the `mix.exs` is supported, but I'll add more as the need arises.


## Getting the version from a file

This action allows you to customize the command used to get the version to tag. By default, the following command is used:
```bash
cat mix.exs \
    | grep --line-buffer "version: " \
    | grep --extended-regexp --only-matching "\"[-0-9\.\+a-zA-Z]+\"" \
    | grep --extended-regexp --only-matching "[-0-9\.\+a-zA-Z]+"
```
It is used to read the version defined in `mix.exs`, a file used in elixir projects. Of course, a mode simple command can be used instead by setting the `VERSION_COMMAND` environment variable.
