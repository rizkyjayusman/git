#!/bin/bash

echo "Installing hooks..."

cp .github/hooks/commit-msg .git/hooks/commit-msg
cp .github/hooks/pre-push .git/hooks/pre-push

chmod +x .git/hooks/commit-msg
chmod +x .git/hooks/pre-push

echo "Completed."
