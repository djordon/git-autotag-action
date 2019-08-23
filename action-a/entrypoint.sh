#!/usr/bin/env bash

APP_VERSION=$(cat mix.exs \
    | grep --line-buffer "version: " \
    | grep --extended-regexp --only-matching "[0-9\.]+")

echo "The version is supposed to be $APP_VERSION"

APP_FULL_VERSION=$(git describe --dirty --tags)

echo