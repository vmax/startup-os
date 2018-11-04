#!/usr/bin/env bash

# This tool updates dependencies at third_party/maven with dependencies.yaml.
# If run from CircleCI, it prints out an error if dependencies are not synced.

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)


export HOME=/home/circleci/
sudo chmod -R a+rwx .
git config --global user.email "cloudbuild@google.com"
git config --global user.name "Google Cloudbuild Service"

git init .
git add -A && git commit -a -m "initial"

# Regenerate dependencies
bazel run //tools:bazel_deps -- generate \
  -r $(pwd) \
  -s third_party/maven/package-lock.bzl \
  -d dependencies.yaml

# Format generated BUILD files
bazel run //tools/formatter -- \
  --path $(pwd)/third_party/maven/ \
  --build

# Print error if on CircleCI and dependencies were not up-to-date
if [[ ! -z $(git status -s) ]]; then
  echo "$RED[!] Dependency tree does not match dependencies.yaml$RESET"
  echo "Please run ''$0'' to fix it"
  git status -v
  exit 1
fi
