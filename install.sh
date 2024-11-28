#!/bin/bash

echo "Installing hooks..."

cp .github/hooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

echo "Completed."
