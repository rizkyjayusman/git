#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Usage: sh gitworkflow.sh <commit> <type> <message>"
  echo "Allowed types: feat, fix, refactor, chore"
  exit 1
fi

ACTION=$1
TYPE=$2
MESSAGE="${@:3}"

if [ "$ACTION" != "commit" ]; then
  echo "ERROR: The first argument must be 'commit'."
  exit 1
fi

if [[ ! "$TYPE" =~ ^(feat|fix|refactor|chore)$ ]]; then
  echo "ERROR: Invalid commit type. Allowed types: feat, fix, refactor, chore."
  exit 1
fi

COMMIT_MSG="$TYPE: $MESSAGE"

git add .
git commit -m "$COMMIT_MSG"

if [ $? -eq 0 ]; then
  echo "Commit successful with message: '$COMMIT_MSG'"
else
  echo "ERROR: Commit failed."
  exit 1
fi