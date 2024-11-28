#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Usage: sh gitworkflow.sh <branch|commit> <type> <branch-name|message>"
  echo "Allowed types for branch: feature, bugfix, hotfix"
  echo "Allowed types for commit: feat, fix, refactor, chore"
  exit 1
fi

ACTION=$1
TYPE=$2

if [ "$ACTION" == "branch" ]; then
  if [ "$#" -eq 3 ]; then
    BRANCH_NAME="$TYPE/${@:3}"  # No scope, just type and branch name
  else
    BRANCH_NAME="$TYPE/${@:3:1}/${@:4}"  # With scope, type, scope, and branch name
  fi
  
  PATTERN="^(feature|bugfix|hotfix)(\/[a-zA-Z0-9\-]+)?\/[a-zA-Z0-9\-]+$"
  
  if [[ ! "$BRANCH_NAME" =~ $PATTERN ]]; then
    echo "ERROR: Invalid branch name format."
    echo "Branch name must match the format: <type>/<scope>/<branch-name> or <type>/<branch-name>"
    echo "Allowed types: feature, bugfix, hotfix"
    exit 1
  fi
  
  if git show-ref --quiet refs/heads/"$BRANCH_NAME"; then
    echo "ERROR: Branch '$BRANCH_NAME' already exists."
    exit 1
  fi

  git checkout -b "$BRANCH_NAME"
  echo "Switched to new branch '$BRANCH_NAME'"
  
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