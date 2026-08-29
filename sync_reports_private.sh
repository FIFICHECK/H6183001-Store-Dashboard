#!/usr/bin/env bash
# Sync H6183001 XLSX reports to the private repo (h6183001-reports-private)
# Run after downloading new daily reports (cron 13:30), BEFORE committing public repo.
# New XLSX go to local reports/ (gitignored) AND the private repo (for worker /download).
set -e

SRC_DIR="/home/snkwok/H6183001-Store-Dashboard/reports"
PRIV_DIR="/tmp/h6-private"

PAT=$(python3 -c "import re; print(re.search(r'oauth_token:\s*(\S+)', open('/home/snkwok/.config/gh/hosts.yml').read()).group(1))")
REMOTE="https://FIFICHECK:${PAT}@github.com/FIFICHECK/h6183001-reports-private.git"

# fresh pull
git -C "$PRIV_DIR" pull -q --rebase "$REMOTE" main || true

# copy new files (daily + monthly)
cp -n "$SRC_DIR"/order_reports/ECOM-MMSNG_DAILY_ORDER_H6183001_*.xlsx "$PRIV_DIR/" 2>/dev/null || true
cp -n "$SRC_DIR"/monthly/ECOM-MMSNG_DAILY_ORDER_H6183001_*_MONTHLY.xlsx "$PRIV_DIR/" 2>/dev/null || true

# commit + push if changes
if ! git -C "$PRIV_DIR" diff --quiet; then
  git -C "$PRIV_DIR" add -A
  git -C "$PRIV_DIR" commit -q -m "📦 Sync reports $(date +%F)"
  git -C "$PRIV_DIR" push -q "$REMOTE" main
  echo "PRIVATE-SYNC-PUSHED $(date +%F)"
else
  echo "PRIVATE-SYNC-UP-TO-DATE"
fi
