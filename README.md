# Automatic Repo Tagging GitHub Action

This GitHub Action automatically tags your repository with a tag determined by a shell command, and you have control of the shell command. By default, the shell command is `cat VERSION`, so this action looks at the contents of a `VERSION` file in the repository when determining what the tag should be. Some notes:
1. Suppose the shell command is `cat VERSION` and the contents of the `VERSION` file is `1.2.3-rc1`, then the default behavior is to have the repo tagged with `1.2.3-rc1` when this action is run. You can choose to have a string prefix the output of the version command. If `VERSION_PREFIX=v` then the repo would be tagged with `v1.2.3-rc1`.
2. If the repo is already tagged with the version then no attempt is made to tag the repo and nothing happens.

Below are some example shell commands that determine the version.


## Getting the version from a file

This action allows the user to customize the command used to get the name of the tag. This is done by setting a `VERSION_COMMAND` environment variable. Some languages allow you (or require you) to set the version in some config file. I've included some example `main.yaml`s with an appropriate `VERSION_COMMAND`.


### Rust

For `rust`, you can do something like the following:
```yaml
...
    - name: Tagging repo using version specified in Cargo.toml
      uses: djordon/git-autotag-action@v0.5.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VERSION_PREFIX: v
        VERSION_COMMAND: >
          cat Cargo.toml
            | grep --extended-regexp "^version ="
            | grep --extended-regexp --only-matching "[0-9]+\.[0-9]+.[0-9]+[-\.\+a-zA-Z0-9]*"
            | head --lines=1
```


### Elixir

For `elixir`, the `main.yaml` below can be used to read the version defined in `mix.exs` (assuming the `version` key is on it's own line in the `project` section of `mix.exs`):
```yaml
name: Creates a tag for the repo
  push:
    branches:
      - master 
jobs:
  build:
    name: Tag repo using mix.exs file
    runs-on: ubuntu-20.04    
    steps:
    - name: Checkout master
      uses: actions/checkout@master
    - name: Tagging repo using version specified in mix.exs
      uses: djordon/git-autotag-action@v0.5.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VERSION_PREFIX: v
        VERSION_COMMAND: >
          cat mix.exs
            | grep --line-buffer "version: "
            | grep --extended-regexp --only-matching "\"[-0-9\.\+a-zA-Z]+\""
            | grep --extended-regexp --only-matching "[-0-9\.\+a-zA-Z]+"
```
