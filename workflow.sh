#!/bin/bash

MAIN_BRANCH="main"
DEVELOPMENT_BRANCH="development"

if [ "$#" -lt 3 ]; then
  echo "Usage: sh gitworkflow.sh <branch|commit> <type> <branch-name|scope branch-name>"
  echo "Allowed branch types: feature, bugfix, hotfix"
  echo "Allowed commit types: feat, fix, refactor, chore"
  exit 1
fi

ACTION=$1
TYPE=$2

if [ "$ACTION" == "branch" ]; then
  if [ "$#" -eq 3 ]; then
    BRANCH_NAME="$TYPE/${@:3}" # No scope
  else
    BRANCH_NAME="$TYPE/${@:3:1}/${@:4}" # With scope
  fi

  BASE_BRANCH=""
  if [ "$TYPE" == "feature" ]; then
    BASE_BRANCH=$DEVELOPMENT_BRANCH
  elif [ "$TYPE" == "bugfix" ]; then
    BASE_BRANCH=$DEVELOPMENT_BRANCH
  elif [ "$TYPE" == "hotfix" ]; then
    BASE_BRANCH=$MAIN_BRANCH
  else
    echo "ERROR: Invalid branch type. Allowed types: feature, bugfix, hotfix."
    exit 1
  fi

  PATTERN="^(feature|bugfix|hotfix)(\/[a-zA-Z0-9\-]+)?\/[a-zA-Z0-9\-]+$"
  if [[ ! "$BRANCH_NAME" =~ $PATTERN ]]; then
    echo "ERROR: Invalid branch name format."
    echo "Branch name must match the format: <type>/<scope>/<branch-name> or <type>/<branch-name>"
    exit 1
  fi

  if git show-ref --quiet refs/heads/"$BRANCH_NAME"; then
    echo "ERROR: Branch '$BRANCH_NAME' already exists."
    exit 1
  fi

  git checkout "$BASE_BRANCH" || exit 1
  git pull origin "$BASE_BRANCH" || exit 1

  git checkout -b "$BRANCH_NAME"
  echo "Switched to new branch '$BRANCH_NAME' from '$BASE_BRANCH'"

elif [ "$ACTION" == "commit" ]; then
  MESSAGE="${@:3}"

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
else
  echo "ERROR: Invalid action. Use 'branch' or 'commit'."
  exit 1
fi