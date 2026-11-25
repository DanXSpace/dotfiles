#!/usr/bin/env bash
# Report the sign-ins this setup can't do for you. Runs on every apply; changes nothing.
eval "$(mise env -s bash)" 2>/dev/null
todo=()
gh auth status >/dev/null 2>&1 || todo+=("gh auth login")
codex login status >/dev/null 2>&1 || todo+=("codex login   (the Codex reviewer seat in /interrogate)")
if [ ${#todo[@]} -gt 0 ]; then
  echo "Left for you:"
  printf '  - %s\n' "${todo[@]}"
fi
