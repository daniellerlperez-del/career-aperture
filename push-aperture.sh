#!/bin/bash
set -e
cd ~/Desktop/career-aperture

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  Career Aperture — Push dev→preview→pub  ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Remove stale lock if present
rm -f .git/index.lock 2>/dev/null && echo "✓ Lock cleared" || true

# ── Commit message ────────────────────────────────────────────────────────────
if [ -n "$1" ]; then
  MSG="$1"
else
  echo "Enter commit message (or press Enter for default):"
  read -r MSG
  if [ -z "$MSG" ]; then
    MSG="chore: sync pages, cursor, preview gate, Netlify URL update"
  fi
fi
echo "✓ Message: $MSG"

# ── Safety check ──────────────────────────────────────────────────────────────
echo ""
echo "▶ Running safety check..."

# 1. PII / sensitive content
HITS=$(grep -ric "63,000\|44,100\|hrets-us@\|DocuSign.*5/13" \
  career-aperture.html kpi.html morning-brief.html 2>/dev/null \
  | awk -F: '{sum+=$NF} END{print sum+0}')
if [ "$HITS" -gt 0 ]; then
  echo "❌ Sensitive content found — aborting."
  exit 1
fi
echo "✓ No sensitive content"

# 2. Preview gate must only fire on preview-- URLs
#    Correct pattern:  isPreview = h.indexOf('preview--') !== -1
#    Wrong pattern:    if (isLocal) return;   (fires on all deployed envs)
GATE_FILES="career-aperture.html kpi.html morning-brief.html"
for f in $GATE_FILES; do
  [ -f "$f" ] || continue
  # Must have the preview-only guard
  if ! grep -q "isPreview.*preview--" "$f"; then
    echo "❌ $f: preview gate missing preview-only guard (isPreview check) — aborting."
    exit 1
  fi
  # Must NOT have the old bare isLocal-only guard before the KEY line
  if grep -A1 "isLocal.*indexOf.*hostname" "$f" 2>/dev/null | grep -q "if (isLocal) return"; then
    echo "❌ $f: preview gate fires on all non-local envs — fix before pushing."
    exit 1
  fi
done
echo "✓ Preview gate scoped to preview-- only"

# ── Carry uncommitted changes to dev ─────────────────────────────────────────
CURRENT=$(git branch --show-current)
echo ""
echo "▶ Current branch: $CURRENT"

if [ "$CURRENT" != "dev" ]; then
  echo "▶ Stashing uncommitted changes and switching to dev..."
  git stash push -u -m "aperture-push-stash"
  git checkout dev
  git stash pop
  echo "✓ Changes carried to dev"
fi

# ── Commit to dev ─────────────────────────────────────────────────────────────
echo ""
echo "▶ Committing to dev..."
for _f in career-aperture.html kpi.html morning-brief.html README.md .gitignore ARCHITECTURE_REVIEW.md push-aperture.sh; do
  [ -f "$_f" ] && git add "$_f" || true
done
git commit -m "$MSG" || echo "✓ Nothing new to commit on dev"
git push origin dev
echo "✓ dev pushed"

# ── Promote to preview ────────────────────────────────────────────────────────
echo ""
echo "▶ Promoting to preview..."
git checkout preview
git merge dev --no-edit
git push origin preview
git checkout dev
echo "✓ preview pushed → https://preview--career-aperture-pcl.netlify.app"

# ── Promote to public (LIVE) ──────────────────────────────────────────────────
echo ""
echo "▶ Promoting to public (LIVE)..."
git checkout public
git merge dev --no-edit
git push origin public
git checkout dev
echo "✓ public pushed → https://career-aperture-pcl.netlify.app"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  ✅ All branches pushed successfully      ║"
echo "╚══════════════════════════════════════════╝"
echo ""
git log --oneline -5
