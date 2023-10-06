#! /bin/bash

set -euo pipefail

export COMPOSE_FILE=docker-compose.yml

database_dir="tmp/db"
storage_dir="storage"
storage_test_dir="tmp/storage"

prompt_for_confirmation() {
  while true; do
    echo "Using --reset will wipe your local database, redis and all files you uploaded to the storage."
    read -rp "Do you want to continue? (yes/no): " answer
    case $answer in
      [Yy]|[Yy][Ee][Ss])
        break
        ;;
      [Nn]|[Nn][Oo])
        echo "Exiting"
        exit
        ;;
      *)
        echo "Please enter 'yes' or 'no'."
        ;;
    esac
  done
}

# check for the reset flag
reset=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --reset)
      reset=true
      shift
      ;;
    *)
      echo "Unrecognized argument: $1"
      exit 1
      ;;
  esac
done

if [ "$reset" = true ]; then
  prompt_for_confirmation
fi

# 1) Stop running containers
docker compose stop

# 2) Reset storage and containers if --reset has been provided
if [ "$reset" = true ]; then
  # 2.1) Remove existing containers (also resets Redis)
  docker compose down

  # 2.2) Remove db volume
  rm -rf $database_dir

  # 2.3) Delete all attachments in storage
  # Otherwise the build may take forever if many files are present in the storage
  find $storage_dir -mindepth 1 -not -name '.keep' -delete

  # 3.4) Delete all attachments in storage used by testing
  rm -rf $storage_test_dir
fi

# 3) Build images
docker compose build

# 4.1) Start db and redis for database setup
docker compose up -d --no-deps db

# 4.2) Prepare db
docker compose run --entrypoint 'sh -c' --no-deps --rm -it web 'RAILS_ENV=test rails db:create db:schema:load'
docker compose run --entrypoint 'sh -c' --no-deps --rm -it web 'rails db:create db:migrate'

# 4.3) Seed db if --reset has been provided
if [ "$reset" = true ]; then
docker compose run --entrypoint 'sh -c' --no-deps --rm -it web 'rails db:seed'
fi

# 5) Start application
docker compose up -d
