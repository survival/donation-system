#!/bin/bash

set -e

ensure_right_directory() {
  RELATIVE_ROOT_DIR="$(dirname ${BASH_SOURCE[0]})"/..
  cd $RELATIVE_ROOT_DIR
}

extract_latest_credentials() {
  CREDENTIALS_REPO_URL='https://gitlab.com/survival/donation-system-credentials.git'
  CREDENTIALS_DIR='credentials'

  if [ -d "$CREDENTIALS_DIR" ]
  then
    (cd "$CREDENTIALS_DIR" && git fetch origin && git reset --hard origin/master)
  else
    git clone "$CREDENTIALS_REPO_URL" "$CREDENTIALS_DIR"
  fi
}

run_credentials() {
  echo "Running credentials ..."
  . credentials/.env_test
  . credentials/.email_server
}

main() {
  ensure_right_directory
  extract_latest_credentials
  run_credentials
}

main
bundle install
bundle exec rake

