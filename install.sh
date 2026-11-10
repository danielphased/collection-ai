#!/usr/bin/env bash
# collection-ai installer: puts subagents, skills and plugins where Claude Code looks for them.
#
#   ./install.sh                      this repo's subagents and skills, for you (~/.claude)
#   ./install.sh --third-party        other people's skills and plugins (fetched from their own repos)
#   ./install.sh --all                both
#   ./install.sh --list               show everything available
#   ./install.sh --only verify,api-design
#   ./install.sh --project            install into ./.claude (this project only)
#
# Without a clone:
#   curl -fsSL https://raw.githubusercontent.com/danielphased/collection-ai/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/danielphased/collection-ai/main/install.sh | bash -s -- --all --dry-run
#
# What it does: copies files into the agents/ and skills/ folders, and runs `claude plugin` for
# plugins. It never touches settings, hooks or credentials, and it skips what already exists
# unless you pass --force. Third-party skills are pinned to an exact commit in third-party.tsv.
set -euo pipefail

REPO="danielphased/collection-ai"
BRANCH="main"

set_own=1; set_third=0
k_agents=0; k_skills=0; k_plugins=0
only=""; project=0; force=0; list=0; uninstall=0; dry=0

usage() {
  cat <<'EOF'
collection-ai installer

What to install (default: this repo's subagents and skills):
  --third-party   only third-party skills and plugins (fetched from their original repos)
  --all           this repo's items and the third-party ones
  --agents        only subagents            \
  --skills        only skills                > combine to pick several kinds
  --plugins       only plugins              /
  --only a,b,c    only the named items (see --list)

Where:
  --project       install into ./.claude (and project scope for plugins) instead of ~/.claude

Other:
  --force         overwrite items that already exist (default: skip them)
  --list          list what is available and exit
  --uninstall     remove the selected items instead of installing
  --dry-run       show what would happen, change nothing
  -h, --help      this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --third-party) set_own=0; set_third=1 ;;
    --all) set_own=1; set_third=1 ;;
    --agents) k_agents=1 ;;
    --skills) k_skills=1 ;;
    --plugins) k_plugins=1 ;;
    --only) shift; only="${1:-}"; [ -n "$only" ] || { echo "--only needs a comma-separated list" >&2; exit 2; } ;;
    --project) project=1 ;;
    --force) force=1 ;;
    --list) list=1 ;;
    --uninstall) uninstall=1 ;;
    --dry-run) dry=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
if [ $((k_agents + k_skills + k_plugins)) -eq 0 ]; then k_agents=1; k_skills=1; k_plugins=1; fi

# --- temp dir and source ---------------------------------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

here=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [ -n "$here" ] && [ -d "$here/agents" ] && [ -d "$here/skills" ]; then
  src="$here"
else
  command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
  command -v tar >/dev/null || { echo "tar is required" >&2; exit 1; }
  echo "Downloading $REPO ($BRANCH)..."
  mkdir -p "$tmp/self"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$tmp/self" --strip-components=1
  src="$tmp/self"
fi

if [ "$project" = 1 ]; then base="$PWD/.claude"; scope="project"; else base="${HOME}/.claude"; scope="user"; fi

# --- catalogue -------------------------------------------------------------------
manifest="$src/third-party.tsv"
third_items() { [ -f "$manifest" ] && grep -v -e '^#' -e '^[[:space:]]*$' "$manifest" || true; }
agent_names() { for f in "$src"/agents/*.md; do basename "$f" .md; done; }
skill_names() { for d in "$src"/skills/*/; do basename "$d"; done; }

selected() {
  [ -z "$only" ] && return 0
  case ",$only," in *",$1,"*) return 0 ;; *) return 1 ;; esac
}

if [ "$list" = 1 ]; then
  echo "This repo, subagents:"; agent_names | sed 's/^/  /'
  echo "This repo, skills:";    skill_names | sed 's/^/  /'
  echo "Third-party (install with --third-party):"
  third_items | awk -F'\t' '{ if ($1=="skill") printf "  skill   %-28s %s @ %s  (%s)\n", $2, $3, substr($4,1,7), $6; else printf "  plugin  %-28s %s  (%s)\n", $2, $3, $6 }'
  exit 0
fi

if [ -n "$only" ]; then
  all=" $(agent_names | tr '\n' ' ') $(skill_names | tr '\n' ' ') $(third_items | cut -f2 | tr '\n' ' ')"
  oldifs="$IFS"; IFS=','
  for n in $only; do
    case "$all" in *" $n "*) ;; *) IFS="$oldifs"; echo "Unknown name: $n (try --list)" >&2; exit 2 ;; esac
  done
  IFS="$oldifs"
fi

installed=0; skipped=0; removed=0; failed=0
if [ "$dry" = 1 ]; then v_inst="would install"; v_rem="would remove"; else v_inst="installed"; v_rem="removed"; fi
run() { if [ "$dry" = 1 ]; then echo "  [dry-run] $*"; else "$@"; fi; }

# --- this repo's subagents and skills ---------------------------------------------
do_agent() {
  local n="$1" from="$src/agents/$1.md" to="$base/agents/$1.md"
  if [ "$uninstall" = 1 ]; then
    if [ -e "$to" ]; then run rm -f "$to"; echo "  $v_rem agent  $n"; removed=$((removed+1)); fi
    return 0
  fi
  if [ -e "$to" ] && [ "$force" != 1 ]; then echo "  skipped agent  $n (exists, use --force)"; skipped=$((skipped+1)); return 0; fi
  run mkdir -p "$base/agents"; run cp "$from" "$to"
  echo "  $v_inst agent  $n"; installed=$((installed+1))
}

place_skill() { # place_skill name source_dir
  local n="$1" from="$2" to="$base/skills/$1"
  if [ -e "$to" ] && [ "$force" != 1 ]; then echo "  skipped skill  $n (exists, use --force)"; skipped=$((skipped+1)); return 0; fi
  run mkdir -p "$base/skills"; run rm -rf "$to"; run cp -R "$from" "$to"
  echo "  $v_inst skill  $n"; installed=$((installed+1))
}

remove_skill() {
  local n="$1" to="$base/skills/$1"
  if [ -d "$to" ]; then run rm -rf "$to"; echo "  $v_rem skill  $n"; removed=$((removed+1)); fi
}

if [ "$set_own" = 1 ]; then
  echo "Target: $base"
  if [ "$k_agents" = 1 ]; then for n in $(agent_names); do selected "$n" && do_agent "$n"; done; fi
  if [ "$k_skills" = 1 ]; then
    for n in $(skill_names); do
      selected "$n" || continue
      if [ "$uninstall" = 1 ]; then remove_skill "$n"; else place_skill "$n" "$src/skills/$n"; fi
    done
  fi
fi

# --- third-party skills and plugins -----------------------------------------------
fetch_sparse() { # fetch_sparse repo sha dir path...   (only the given paths, exact commit)
  local repo="$1" sha="$2" dir="$3"; shift 3
  mkdir -p "$dir"
  git -C "$dir" init -q
  git -C "$dir" remote add origin "https://github.com/$repo.git"
  git -C "$dir" sparse-checkout set "$@"
  git -C "$dir" fetch -q --depth 1 --filter=blob:none origin "$sha"
  git -C "$dir" -c advice.detachedHead=false checkout -q FETCH_HEAD
}

if [ "$set_third" = 1 ]; then
  sel="$tmp/third.sel"; : > "$sel"
  third_items | while IFS="$(printf '\t')" read -r type name repo ref path lic; do
    selected "$name" || continue
    case "$type" in
      skill)  [ "$k_skills" = 1 ]  || continue ;;
      plugin) [ "$k_plugins" = 1 ] || continue ;;
    esac
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$type" "$name" "$repo" "$ref" "$path" "$lic" >> "$sel"
  done

  echo "Third-party items (fetched from their original owners; not part of this repo):"
  awk -F'\t' '{ if ($1=="skill") printf "  %-26s %s @ %s  licence: %s\n", $2, $3, substr($4,1,7), $6; else printf "  %-26s plugin from %s  licence: %s\n", $2, $3, $6 }' "$sel"
  [ -s "$sel" ] || echo "  (nothing selected)"

  # skills: one sparse fetch per repo+commit
  if [ "$uninstall" != 1 ] && grep -q '^skill' "$sel" 2>/dev/null; then
    command -v git >/dev/null || { echo "git is required for third-party skills" >&2; exit 1; }
  fi
  if [ "$k_skills" = 1 ]; then
    echo "Skills, target: $base/skills"
    if [ "$uninstall" = 1 ]; then
      while read -r n; do remove_skill "$n"; done < <(awk -F'\t' '$1=="skill"{print $2}' "$sel")
    else
      groups="$tmp/groups"; awk -F'\t' '$1=="skill"{print $3"\t"$4}' "$sel" | sort -u > "$groups"
      gi=0
      while IFS="$(printf '\t')" read -r grepo gsha; do
        gi=$((gi+1)); gdir="$tmp/g$gi"
        paths="$(awk -F'\t' -v r="$grepo" -v s="$gsha" '$1=="skill" && $3==r && $4==s {print $5}' "$sel")"
        if [ "$dry" = 1 ]; then
          awk -F'\t' -v r="$grepo" -v s="$gsha" '$1=="skill" && $3==r && $4==s {print "  would install skill  "$2"  (from "r" @ "substr(s,1,7)")"}' "$sel"
          installed=$((installed + $(printf '%s\n' "$paths" | wc -l)))
          continue
        fi
        # shellcheck disable=SC2086
        if ! fetch_sparse "$grepo" "$gsha" "$gdir" $paths 2>"$tmp/git.err"; then
          echo "  FAILED to fetch $grepo @ $(printf %.7s "$gsha"): $(tail -1 "$tmp/git.err")" >&2; failed=$((failed+1)); continue
        fi
        while IFS="$(printf '\t')" read -r n p; do
          if [ -f "$gdir/$p/SKILL.md" ]; then place_skill "$n" "$gdir/$p"; else echo "  FAILED $n: $p/SKILL.md not found in $grepo" >&2; failed=$((failed+1)); fi
        done < <(awk -F'\t' -v r="$grepo" -v s="$gsha" '$1=="skill" && $3==r && $4==s {print $2"\t"$5}' "$sel")
      done < "$groups"
    fi
  fi

  # plugins: through the claude CLI
  if [ "$k_plugins" = 1 ] && grep -q '^plugin' "$sel" 2>/dev/null; then
    echo "Plugins, scope: $scope"
    awk -F'\t' '$1=="plugin"{print $2"\t"$3"\t"$4}' "$sel" | while IFS="$(printf '\t')" read -r n repo market; do
      if [ "$uninstall" = 1 ]; then cmd="claude plugin uninstall $n@$market --scope $scope"
      else cmd="claude plugin marketplace add $repo --scope $scope && claude plugin install $n@$market --scope $scope"; fi
      if [ "$dry" = 1 ]; then echo "  [dry-run] $cmd"
      elif command -v claude >/dev/null; then
        echo "  $n:"; if sh -c "$cmd" >"$tmp/plugin.out" 2>&1; then echo "    done"; else echo "    could not finish: $(tail -1 "$tmp/plugin.out")"; fi
      else
        echo "  $n: 'claude' not found. In Claude Code run:"
        echo "    /plugin marketplace add $repo"
        echo "    /plugin install $n@$market"
      fi
    done
  fi
fi

echo
if [ "$uninstall" = 1 ]; then
  echo "Done: $removed $v_rem."
else
  echo "Done: $installed $v_inst, $skipped skipped$([ "$failed" -gt 0 ] && echo ", $failed failed")."
  [ "$installed" -gt 0 ] && [ "$dry" != 1 ] && echo "Start a new Claude Code session to use them (check agents with /agents)."
fi
exit 0
