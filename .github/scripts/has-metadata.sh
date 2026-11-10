#!/usr/bin/env bash
# Prints "true" when force-app contains deployable files (anything except .gitkeep), "false" otherwise.
set -euo pipefail
if find force-app -type f ! -name '.gitkeep' -print -quit | grep -q .; then
  echo "true"
else
  echo "false"
fi
