#!/usr/bin/env bash
# Installer for a Claude Code collection repo: puts subagents, skills, engineering standards, hooks,
# MCP servers and plugins where Claude Code looks for them.
#
#   ./install.sh                      subagents, skills and engineering standards of this repo (~/.claude)
#   ./install.sh --third-party        other people's skills and plugins
#   ./install.sh --all                both
#   ./install.sh --hooks --mcp        opt-in: shared hooks (edits settings.json) and MCP servers
#   ./install.sh --list               show everything available
#   ./install.sh --status             compare this repo with what is installed
#   ./install.sh --only verify,api-design
#   ./install.sh --project            install into ./.claude (this project only)
#
# Without a clone (public repos only):
#   curl -fsSL https://raw.githubusercontent.com/danielphased/collection-ai/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/danielphased/collection-ai/main/install.sh | bash -s -- --all --dry-run
#
# What it does: copies files into the agents/, skills/ and engineering/ folders and runs `claude plugin`
# for plugins. It skips what already exists unless --force. It touches settings.json only with --hooks
# (after a backup) and adds MCP servers only with --mcp. It never touches credentials.
# Third-party skills are pinned to an exact commit in third-party.tsv, or kept as local copies in
# third-party/skills/ when the repo has that folder.
set -euo pipefail

REPO="danielphased/collection-ai"
BRANCH="main"

set_own=1; set_third=0
k_agents=0; k_skills=0; k_plugins=0; k_eng=0; k_hooks=0; k_mcp=0
only=""; project=0; force=0; list=0; uninstall=0; dry=0; status=0; capture=0

usage() {
  cat <<'EOF'
Collection installer for Claude Code

What (default: this repo's subagents, skills and engineering standards):
  --third-party   only third-party skills and plugins
  --all           this repo's items and the third-party ones
  --agents        only subagents                 \
  --skills        only skills                     |
  --engineering   only engineering standards      > combine to pick several kinds
  --plugins       only plugins (third-party)      |
  --hooks         shared hooks: copies the scripts and merges hooks.json into settings.json (backup first)
  --mcp           MCP servers from mcp.json (user scope), added through the claude CLI
  --only a,b,c    only the named items (see --list)

Where:
  --project       install into ./.claude (project scope) instead of ~/.claude

Actions (default: install):
  --list          list what is available and exit
  --status        compare the repo with the installed copies (same / differs / not installed)
  --capture       copy installed copies that differ back INTO this repo (only items the repo already has)
  --uninstall     remove the selected items

Other:
  --force         overwrite items that already exist (default: skip them)
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
    --engineering) k_eng=1 ;;
    --hooks) k_hooks=1 ;;
    --mcp) k_mcp=1 ;;
    --only) shift; only="${1:-}"; [ -n "$only" ] || { echo "--only needs a comma-separated list" >&2; exit 2; } ;;
    --project) project=1 ;;
    --force) force=1 ;;
    --list) list=1 ;;
    --status) status=1 ;;
    --capture) capture=1 ;;
    --uninstall) uninstall=1 ;;
    --dry-run) dry=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
# no kind named: the copy-only kinds. Hooks and MCP change configuration, so they are always opt-in.
if [ $((k_agents + k_skills + k_plugins + k_eng + k_hooks + k_mcp)) -eq 0 ]; then
  k_agents=1; k_skills=1; k_plugins=1; k_eng=1
fi

# --- temp dir and source ---------------------------------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

here=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [ -n "$here" ] && [ -d "$here/agents" ] && [ -d "$here/skills" ]; then
  src="$here"; cloned=1
else
  command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
  command -v tar >/dev/null || { echo "tar is required" >&2; exit 1; }
  echo "Downloading $REPO ($BRANCH)..."
  mkdir -p "$tmp/self"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$tmp/self" --strip-components=1
  src="$tmp/self"; cloned=0
fi

if [ "$project" = 1 ]; then base="$PWD/.claude"; scope="project"; else base="${HOME}/.claude"; scope="user"; fi

# --- catalogue -------------------------------------------------------------------
manifest="$src/third-party.tsv"
third_items() { if [ -f "$manifest" ]; then grep -v -e '^#' -e '^[[:space:]]*$' "$manifest" || true; fi; }
names_in() { # names_in <dir> <suffix or /> : base names of files with suffix, or of sub-folders
  local d="$1" suf="$2" f
  [ -d "$d" ] || return 0
  if [ "$suf" = "/" ]; then for f in "$d"/*/; do [ -d "$f" ] && basename "$f"; done
  else for f in "$d"/*"$suf"; do [ -f "$f" ] && basename "$f" "$suf"; done; fi
  return 0
}
agent_names()  { names_in "$src/agents" .md; }
skill_names()  { names_in "$src/skills" /; }
eng_names()    { names_in "$src/engineering" .md; }
hook_names()   { names_in "$src/hooks" .sh; }
local3_names() { names_in "$src/third-party/skills" /; }
mcp_names()    { if [ -f "$src/mcp.json" ]; then python3 -c 'import json,sys
for k in json.load(open(sys.argv[1])): print(k)' "$src/mcp.json" 2>/dev/null || true; fi; }

selected() {
  [ -z "$only" ] && return 0
  case ",$only," in *",$1,"*) return 0 ;; *) return 1 ;; esac
}

if [ "$list" = 1 ]; then
  echo "Subagents:";             agent_names | sed 's/^/  /'
  echo "Skills:";                skill_names | sed 's/^/  /'
  if [ -n "$(eng_names)" ];    then echo "Engineering standards:"; eng_names | sed 's/^/  /'; fi
  if [ -n "$(hook_names)" ];   then echo "Hooks (opt-in, --hooks):"; hook_names | sed 's/^/  /'; fi
  if [ -n "$(mcp_names)" ];    then echo "MCP servers (opt-in, --mcp):"; mcp_names | sed 's/^/  /'; fi
  if [ -n "$(local3_names)" ]; then echo "Third-party skills, local copies (--third-party):"; local3_names | sed 's/^/  /'; fi
  if [ -n "$(third_items)" ]; then
    echo "Third-party, fetched from their owners (--third-party):"
    third_items | awk -F'\t' '{ if ($1=="skill") printf "  skill   %-28s %s @ %s  (%s)\n", $2, $3, substr($4,1,7), $6; else printf "  plugin  %-28s %s  (%s)\n", $2, $3, $6 }'
  fi
  exit 0
fi

if [ -n "$only" ]; then
  all=" $(agent_names | tr '\n' ' ') $(skill_names | tr '\n' ' ') $(eng_names | tr '\n' ' ') $(hook_names | tr '\n' ' ') $(mcp_names | tr '\n' ' ') $(local3_names | tr '\n' ' ') $(third_items | cut -f2 | tr '\n' ' ')"
  oldifs="$IFS"; IFS=','
  for n in $only; do
    case "$all" in *" $n "*) ;; *) IFS="$oldifs"; echo "Unknown name: $n (try --list)" >&2; exit 2 ;; esac
  done
  IFS="$oldifs"
fi

installed=0; skipped=0; removed=0; failed=0
if [ "$dry" = 1 ]; then v_inst="would install"; v_rem="would remove"; else v_inst="installed"; v_rem="removed"; fi
run() { if [ "$dry" = 1 ]; then echo "  [dry-run] $*"; else "$@"; fi; }

# --- status / capture: compare the repo with the installed copies -------------------
same_item() { # same_item <repo path> <installed path>
  if [ -d "$1" ]; then diff -rq -x .DS_Store -x __pycache__ "$1" "$2" >/dev/null 2>&1
  else cmp -s "$1" "$2"; fi
}
compare() { # compare <kind> <name> <repo path> <installed path>
  local kind="$1" n="$2" r="$3" i="$4"
  if [ ! -e "$i" ]; then
    if [ "$capture" != 1 ]; then printf '  %-11s %-34s not installed\n' "$kind" "$n"; fi
    c_missing=$((c_missing+1)); return 0
  fi
  if same_item "$r" "$i"; then c_same=$((c_same+1)); return 0; fi
  c_diff=$((c_diff+1))
  if [ "$capture" = 1 ]; then
    if [ -d "$r" ]; then run rm -rf "$r"; run cp -R "$i" "$r"; run find "$r" -name __pycache__ -prune -exec rm -rf {} +
    else run cp "$i" "$r"; fi
    printf '  %-11s %-34s captured into the repo\n' "$kind" "$n"
    if [ "$dry" != 1 ] && grep -rIlF -- "$HOME" "$r" >/dev/null 2>&1; then
      printf '      WARNING: it contains your home path (%s) - replace it before committing\n' "$HOME"
    fi
  else
    printf '  %-11s %-34s DIFFERS\n' "$kind" "$n"
  fi
  return 0
}
if [ "$status" = 1 ] || [ "$capture" = 1 ]; then
  if [ "$capture" = 1 ] && [ "$cloned" != 1 ]; then echo "--capture needs a clone of the repo" >&2; exit 2; fi
  c_same=0; c_diff=0; c_missing=0
  echo "Repo:      $src"
  echo "Installed: $base"
  if [ "$set_own" = 1 ]; then
    if [ "$k_agents" = 1 ]; then for n in $(agent_names); do if selected "$n"; then compare agent "$n" "$src/agents/$n.md" "$base/agents/$n.md"; fi; done; fi
    if [ "$k_skills" = 1 ]; then for n in $(skill_names); do if selected "$n"; then compare skill "$n" "$src/skills/$n" "$base/skills/$n"; fi; done; fi
    if [ "$k_eng" = 1 ];    then for n in $(eng_names);   do if selected "$n"; then compare standard "$n" "$src/engineering/$n.md" "$base/engineering/$n.md"; fi; done; fi
    if [ "$k_hooks" = 1 ];  then for n in $(hook_names);  do if selected "$n"; then compare hook "$n" "$src/hooks/$n.sh" "$base/hooks/$n.sh"; fi; done; fi
  fi
  if [ "$set_third" = 1 ] && [ "$k_skills" = 1 ]; then
    for n in $(local3_names); do if selected "$n"; then compare third-party "$n" "$src/third-party/skills/$n" "$base/skills/$n"; fi; done
  fi
  echo
  if [ "$capture" = 1 ]; then echo "Done: $c_diff captured, $c_same already the same, $c_missing not installed. Review with 'git diff' before committing."
  else echo "Done: $c_same same, $c_diff differ, $c_missing not installed."; fi
  exit 0
fi

# --- copy helpers -------------------------------------------------------------------
place_file() { # place_file <kind> <name> <from> <to>
  local kind="$1" n="$2" from="$3" to="$4"
  if [ "$uninstall" = 1 ]; then
    if [ -e "$to" ]; then run rm -f "$to"; echo "  $v_rem $kind  $n"; removed=$((removed+1)); fi
    return 0
  fi
  if [ -e "$to" ] && [ "$force" != 1 ]; then echo "  skipped $kind  $n (exists, use --force)"; skipped=$((skipped+1)); return 0; fi
  run mkdir -p "$(dirname "$to")"; run cp "$from" "$to"
  echo "  $v_inst $kind  $n"; installed=$((installed+1))
  return 0
}

place_skill() { # place_skill name source_dir
  local n="$1" from="$2" to="$base/skills/$1"
  if [ -e "$to" ] && [ "$force" != 1 ]; then echo "  skipped skill  $n (exists, use --force)"; skipped=$((skipped+1)); return 0; fi
  run mkdir -p "$base/skills"; run rm -rf "$to"; run cp -R "$from" "$to"
  echo "  $v_inst skill  $n"; installed=$((installed+1))
  return 0
}

remove_skill() {
  local n="$1" to="$base/skills/$1"
  if [ -d "$to" ]; then run rm -rf "$to"; echo "  $v_rem skill  $n"; removed=$((removed+1)); fi
  return 0
}

# --- this repo: subagents, skills, engineering standards ----------------------------
if [ "$set_own" = 1 ]; then
  echo "Target: $base"
  if [ "$k_agents" = 1 ]; then for n in $(agent_names); do if selected "$n"; then place_file agent "$n" "$src/agents/$n.md" "$base/agents/$n.md"; fi; done; fi
  if [ "$k_skills" = 1 ]; then
    for n in $(skill_names); do
      selected "$n" || continue
      if [ "$uninstall" = 1 ]; then remove_skill "$n"; else place_skill "$n" "$src/skills/$n"; fi
    done
  fi
  if [ "$k_eng" = 1 ]; then for n in $(eng_names); do if selected "$n"; then place_file standard "$n" "$src/engineering/$n.md" "$base/engineering/$n.md"; fi; done; fi
fi

# --- hooks (opt-in): scripts + merge into settings.json -----------------------------
if [ "$set_own" = 1 ] && [ "$k_hooks" = 1 ] && [ -n "$(hook_names)" ]; then
  echo "Hooks, target: $base/hooks and $base/settings.json"
  command -v python3 >/dev/null || { echo "python3 is required for --hooks" >&2; exit 1; }
  for n in $(hook_names); do
    selected "$n" || continue
    if [ "$uninstall" = 1 ]; then continue; fi
    if [ -e "$base/hooks/$n.sh" ] && [ "$force" != 1 ]; then
      echo "  kept hook script  $n (exists, use --force to replace)"
    else
      run mkdir -p "$base/hooks"; run cp "$src/hooks/$n.sh" "$base/hooks/$n.sh"; run chmod +x "$base/hooks/$n.sh"
      echo "  $v_inst hook script  $n"; installed=$((installed+1))
    fi
  done
  if [ -f "$src/hooks.json" ]; then
    if [ "$dry" = 1 ]; then
      echo "  [dry-run] merge hooks.json into $base/settings.json (backup first)"
    else
      mkdir -p "$base"
      if [ -f "$base/settings.json" ]; then cp "$base/settings.json" "$base/settings.json.bak-$(date +%Y%m%d-%H%M%S)"; fi
      python3 - "$src/hooks.json" "$base/settings.json" "$base" "$uninstall" <<'PY'
import json, os, sys
src, path, base, uninstall = sys.argv[1:5]
shared = json.loads(open(src).read().replace("{{HOME}}/.claude", base))
s = json.load(open(path)) if os.path.exists(path) else {}
hooks = s.setdefault("hooks", {})
changed = 0
for event, groups in shared.items():
    cmds = {h.get("command") for g in groups for h in g.get("hooks", [])}
    if uninstall == "1":
        kept = []
        for g in hooks.get(event, []):
            hs = [h for h in g.get("hooks", []) if h.get("command") not in cmds]
            changed += len(g.get("hooks", [])) - len(hs)
            if hs:
                kept.append({**g, "hooks": hs})
        if kept:
            hooks[event] = kept
        else:
            hooks.pop(event, None)
    else:
        have = {h.get("command") for g in hooks.get(event, []) for h in g.get("hooks", [])}
        for g in groups:
            new = [h for h in g["hooks"] if h.get("command") not in have]
            if new:
                hooks.setdefault(event, []).append({**g, "hooks": new})
                changed += len(new)
if not hooks:
    s.pop("hooks", None)
json.dump(s, open(path, "w"), indent=2)
open(path, "a").write("\n")
print("  settings.json: %d hook entr%s %s" % (changed, "y" if changed == 1 else "ies", "removed" if uninstall == "1" else "added (existing ones kept)"))
PY
    fi
  fi
  if [ "$uninstall" = 1 ]; then
    for n in $(hook_names); do
      selected "$n" || continue
      if [ -e "$base/hooks/$n.sh" ]; then run rm -f "$base/hooks/$n.sh"; echo "  $v_rem hook script  $n"; removed=$((removed+1)); fi
    done
  fi
fi

# --- MCP servers (opt-in) -----------------------------------------------------------
if [ "$set_own" = 1 ] && [ "$k_mcp" = 1 ] && [ -f "$src/mcp.json" ]; then
  echo "MCP servers, scope: user"
  command -v python3 >/dev/null || { echo "python3 is required for --mcp" >&2; exit 1; }
  python3 -c 'import json,sys
for k,v in json.load(open(sys.argv[1])).items(): print(k+"\t"+json.dumps(v))' "$src/mcp.json" > "$tmp/mcp.list"
  while IFS="$(printf '\t')" read -r name cfg; do
    selected "$name" || continue
    if [ "$uninstall" = 1 ]; then cmd_text="claude mcp remove --scope user $name"
    else cmd_text="claude mcp add-json --scope user $name '$cfg'"; fi
    if [ "$dry" = 1 ]; then echo "  [dry-run] $cmd_text"
    elif ! command -v claude >/dev/null; then echo "  $name: 'claude' not found. Run:  $cmd_text"
    elif [ "$uninstall" = 1 ]; then
      if claude mcp remove --scope user "$name" >/dev/null 2>&1 </dev/null; then echo "  $v_rem MCP server  $name"; removed=$((removed+1)); else echo "  $name: not configured"; fi
    elif claude mcp get "$name" >/dev/null 2>&1 </dev/null; then echo "  skipped MCP server  $name (already configured)"; skipped=$((skipped+1))
    elif claude mcp add-json --scope user "$name" "$cfg" >/dev/null 2>&1 </dev/null; then echo "  $v_inst MCP server  $name"; installed=$((installed+1))
    else echo "  could not add MCP server $name. Run:  $cmd_text"; failed=$((failed+1)); fi
  done < "$tmp/mcp.list"
fi

# --- third-party skills and plugins -------------------------------------------------
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
  # local copies kept in this repo
  if [ "$k_skills" = 1 ] && [ -n "$(local3_names)" ]; then
    echo "Third-party skills (local copies in third-party/skills), target: $base/skills"
    for n in $(local3_names); do
      selected "$n" || continue
      if [ "$uninstall" = 1 ]; then remove_skill "$n"; else place_skill "$n" "$src/third-party/skills/$n"; fi
    done
  fi

  sel="$tmp/third.sel"; : > "$sel"
  third_items | while IFS="$(printf '\t')" read -r type name repo ref path lic; do
    selected "$name" || continue
    case "$type" in
      skill)  [ "$k_skills" = 1 ]  || continue ;;
      plugin) [ "$k_plugins" = 1 ] || continue ;;
    esac
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$type" "$name" "$repo" "$ref" "$path" "$lic" >> "$sel"
  done

  if [ -s "$sel" ]; then
    echo "Third-party items (fetched from their original owners; not part of this repo):"
    awk -F'\t' '{ if ($1=="skill") printf "  %-26s %s @ %s  licence: %s\n", $2, $3, substr($4,1,7), $6; else printf "  %-26s plugin from %s  licence: %s\n", $2, $3, $6 }' "$sel"
  fi

  if [ "$uninstall" != 1 ] && grep -q '^skill' "$sel" 2>/dev/null; then
    command -v git >/dev/null || { echo "git is required for third-party skills" >&2; exit 1; }
  fi
  if [ "$k_skills" = 1 ] && grep -q '^skill' "$sel" 2>/dev/null; then
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

  if [ "$k_plugins" = 1 ] && grep -q '^plugin' "$sel" 2>/dev/null; then
    echo "Plugins, scope: $scope"
    awk -F'\t' '$1=="plugin"{print $2"\t"$3"\t"$4}' "$sel" | while IFS="$(printf '\t')" read -r n repo market; do
      if [ "$uninstall" = 1 ]; then cmd="claude plugin uninstall $n@$market --scope $scope"
      else cmd="claude plugin marketplace add $repo --scope $scope && claude plugin install $n@$market --scope $scope"; fi
      if [ "$dry" = 1 ]; then echo "  [dry-run] $cmd"
      elif command -v claude >/dev/null; then
        echo "  $n:"; if sh -c "$cmd" >"$tmp/plugin.out" 2>&1 </dev/null; then echo "    done"; else echo "    could not finish: $(tail -1 "$tmp/plugin.out")"; fi
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
  if [ "$installed" -gt 0 ] && [ "$dry" != 1 ]; then echo "Start a new Claude Code session to use them (check agents with /agents)."; fi
fi
exit 0
