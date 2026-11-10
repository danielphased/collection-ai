#!/usr/bin/env bash
# PreToolUse hook: block Claude from editing files that usually hold secrets.
# Exit 2 = block the tool call and show the message to Claude.
# Override for one session: CLAUDE_ALLOW_SECRET_EDIT=1 claude

[ "${CLAUDE_ALLOW_SECRET_EDIT:-}" = "1" ] && exit 0

path="$(python3 -c 'import json,sys
d=json.load(sys.stdin).get("tool_input",{})
print(d.get("file_path") or d.get("notebook_path") or "")' 2>/dev/null)"
[ -n "$path" ] || exit 0

name="${path##*/}"
lower="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')"

case "$lower" in
  .env.example|.env.sample|.env.template|.env.dist|.env.defaults) exit 0 ;;
esac

blocked=""
case "$lower" in
  .env|.env.*|*.env)                         blocked="environment file" ;;
  *.pem|*.key|*.p12|*.pfx|*.jks|*.keystore|*.p8|*.mobileprovision) blocked="key or certificate" ;;
  id_rsa|id_rsa.*|id_ed25519|id_ed25519.*|id_ecdsa|id_ecdsa.*) blocked="SSH key" ;;
  .credentials.json|credentials.json|.netrc|.pgpass|*.secret|*secret*.txt|*secret*.json|secrets.y*ml) blocked="credentials file" ;;
esac
case "$path" in
  */.ssh/*|*/.aws/credentials|*/.gnupg/*|*/.docker/config.json|*/.kube/config) blocked="credentials store" ;;
esac

if [ -n "$blocked" ]; then
  echo "Blocked by protect-secrets hook: '$path' looks like a $blocked. Ask the user to edit it by hand, or restart with CLAUDE_ALLOW_SECRET_EDIT=1 if this edit is intended." >&2
  exit 2
fi
exit 0
