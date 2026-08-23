# H6183001 Store Dashboard

H6183001 — MMS Daily Order Report Dashboard

## URL

https://fificheck.github.io/H6183001-Store-Dashboard/

## Features

- 每日 GMV（Column AA: Total Q×U−D=T）
- 訂單行數 / 總件數
- GMV 走勢 chart（Chart.js）
- 訂單報表 XLSX 下載表（23:59 最終版優先）

## Data Flow

1. MMS 2.0 → 訂單報表 → 下載 `ECOM-MMSNG_DAILY_ORDER_H6183001_*.xlsx`（見 `p0068001-daily-order-report` skill）
2. Copy xlsx → `reports/order_reports/`
3. 更新 `data/order_reports_manifest.json`（date, gmv, orders, qty, timestamp, filename）
4. `git add -A && git commit && git push` → GitHub Actions auto-deploy

## Manifest Format

```json
{
  "date": "8月2日",
  "date_iso": "2026-08-02",
  "gmv": "$80,785.60",
  "gmv_raw": 80785.6,
  "orders": 1063,
  "qty": 1219,
  "timestamp": "23:59",
  "filename": "ECOM-MMSNG_DAILY_ORDER_H6183001_20260802235959.xlsx"
}
```

- `timestamp` 23:59 = 最終版；其他 = partial
- Manifest 保持 newest-first 排序
