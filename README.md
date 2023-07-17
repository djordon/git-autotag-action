# A Repo Tagging GitHub Action

This GitHub Action creates a [lightweight tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging) for the repository using head of the repository. Note that if the repo is already tagged with the version then no attempt is made to tag the repo and nothing happens.

It is expected that you compute the version in another step of yout workflow. Below are some example shell commands that you can use to determine the version.


## Getting the tag from a file

Some languages allow you (or require you) to set the version in some config file. I've included some example `main.yaml`s.

### Python

For `python` in `poetry` managed projects you can do something like the following:
```yaml
name: Tagging main using pyproject.toml
on:
  push:
    branches:
      - main
jobs:
  build:
    name: Tag main using pyproject.toml
    runs-on: ubuntu-20.04
    steps:
    - name: Checkout main
      uses: actions/checkout@v3
    - name: The current git state
      run: |
        git fetch --quiet --prune --unshallow --tags
        echo $(git describe --dirty --tags)
    - name: The new tag
      id: computed-tag
      run: |
        set -e
        TAG=$(cat pyproject.toml \
          | grep --extended-regexp "^version =" \
          | grep --extended-regexp --only-matching "[0-9]+\.[0-9]+.[0-9]+[-\.\+a-zA-Z0-9]*" \
          | head --lines=1)
        echo "tag=v$TAG" >> "$GITHUB_OUTPUT"
    - name: Tag main depending on the value in pyproject.toml
      uses: djordon/git-autotag-action@v0.7.0-beta1
      with:
        tag: ${{ steps.computed-tag.outputs.tag }}
```

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
      with:
        tag: ${{ steps.computed-tag.outputs.tag }}
```


### Elixir

For `elixir`, the `yaml` below can be used to read the version defined in `mix.exs` (assuming the `version` key is on it's own line in the `project` section of `mix.exs`):
```yaml
...
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
      with:
        tag: ${{ steps.computed-tag.outputs.tag }}
```
