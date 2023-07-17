# Automatic Repo Tagging GitHub Action

This GitHub Action automatically tags your repository with a tag determined by a shell command, and you have control of the shell command. Some notes:
1. Suppose the shell command is `cat VERSION` and the contents of the `VERSION` file is `1.2.3-rc1`, then the default behavior is to have the repo tagged with `1.2.3-rc1` when this action is run. If the command was `v$(cat VERSION)` then the repo would be tagged with `v1.2.3-rc1`.
2. If the repo is already tagged with the version then no attempt is made to tag the repo and nothing happens.

Below are some example shell commands that determine the version.


## Getting the version from a file

This action sets the version to get the version tag. This can be done by computing the version in another step and passing it to this action. Some languages allow you (or require you) to set the version in some config file. I've included some example `main.yaml`s with an appropriate `where we compute the tag`s.


### Rust

For `rust`, you can do something like the following:
```yaml
...
    - name: The new tag
      id: computed-tag
      run: |
        set -e
        TAG=$(cat Cargo.toml \
          | grep --extended-regexp "^version =" \
          | grep --extended-regexp --only-matching "[0-9]+\.[0-9]+.[0-9]+[-\.\+a-zA-Z0-9]*" \
          | head --lines=1)
        echo "tag=v$TAG" >> "$GITHUB_OUTPUT"
    - name: Tagging repo using version specified in Cargo.toml
      uses: djordon/git-autotag-action@v0.7.0-beta1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag: ${{ steps.computed-tag.outputs.tag }}
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
      uses: actions/checkout@v3
    - name: The new tag
      id: computed-tag
      run: |
        set -e
        TAG=$(cat mix.exs \
          | grep --line-buffer "version: " \
          | grep --extended-regexp --only-matching "\"[-0-9\.\+a-zA-Z]+\"" \
          | grep --extended-regexp --only-matching "[-0-9\.\+a-zA-Z]+")
        echo "tag=v$TAG" >> "$GITHUB_OUTPUT"
    - name: Tagging repo using version specified in mix.exs
      uses: djordon/git-autotag-action@v0.7.0-beta1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag: ${{ steps.computed-tag.outputs.tag }}
```
