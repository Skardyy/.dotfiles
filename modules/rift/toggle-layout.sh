#!/bin/sh
RIFT=/opt/homebrew/bin/rift-cli
cur=$("$RIFT" query workspace-layout | /usr/bin/jq -r '.[] | select(.is_active) | .layout_mode')
if [ "$cur" = "scrolling" ]; then
  "$RIFT" execute workspace set-layout master_stack
else
  "$RIFT" execute workspace set-layout scrolling
fi
