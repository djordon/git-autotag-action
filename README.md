# Automatic Repo Tagging GitHub Action

This GitHub Action automatically tags master with the version in a file. Right now, only the version in the `mix.exs` is supported, but I'll add more as the need arises.


## Getting the version from a file

This action allows the end user to customize the command used to get the version before setting the tag. By default, the following command is used:
```bash
cat mix.exs \
    | grep --line-buffer "version: " \
    | grep --extended-regexp --only-matching "\"[-0-9\.\+a-zA-Z]+\"" \
    | grep --extended-regexp --only-matching "[-0-9\.\+a-zA-Z]+"
```
It is used to read the version defined in `mix.exs`, a file used in elixir projects. 

A custom command can be used by setting the `VERSION_COMMAND` environment variable. For example if your version was in a `VERSION` file in the root of this repository, one could use something like the following in their GitHub Actions yaml file to use this Action:
```yaml
name: Tagging master using VERSION file
on: 
  push:
    branches:
      - master 
jobs:
  build:
    name: Tag master using VERSION file
    runs-on: ubuntu-18.04    
    steps:
    - name: Checkout master
      uses: actions/checkout@master
    - name: Tag master depending on the value in VERSION file
      uses: djordon/git-autotag-action@v0.3.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VERSION_COMMAND: cat VERSION
```
When using something like the above in your repo, updating the contents in the `VERSION` file would auto tag your repo when there was a push to the `master` branch.
