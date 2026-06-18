# Career Aperture

A precision job search and networking CRM for senior PMs — built by Danielle Perez.

Seven modes: Shoot (job search URL builder), Develop (pipeline board), Contact Sheet (network by company), Loupe (Claude-powered deep research), Field Work (SMB prospecting), Reach (networking outreach), and Light Table (company watch list).

Companion pages: Report (pipeline + CRM analytics), Company Fit (AI-scored company/job analysis), KPI (AI usage tracking).

---

## First-Time Setup

### Option A — Local (file://)

1. Clone or download this repo
2. Open `career-builder.html` directly in your browser — no server, no build step
3. Settings → **API Key** → paste your Anthropic key (stored in localStorage only, never synced)
4. Settings → **Deadlines** → add any Layer 2 dates (financial deadlines, legal dates) — these stay browser-local
5. Settings → **Data** → Export JSON to back up your setup

To open companion pages locally: open `report.html`, `company-fit.html`, `kpi.html` in the same browser.

### Option B — Netlify (deployed)

1. Fork or connect this repo to [Netlify](https://app.netlify.com)
2. Build settings: publish directory = `.` (root), no build command
3. **Required:** Add environment variable in Netlify dashboard:
   ```
   ANTHROPIC_API_KEY = sk-ant-api03-...
   ```
   (Site settings → Environment variables → Add variable)
4. Deploy branch: `public` → production
5. Preview branch: `preview` → deploy previews

Without `ANTHROPIC_API_KEY`, all AI features (Loupe, Field Work, Reach) return 500 errors.

---

## Privacy Layers

This tool stores three categories of data. Know which layer your content belongs to before editing source files.

| Layer | What belongs here | Where it lives |
|---|---|---|
| **1 — Source-safe** | Profile text, watch list company names, guardrails, UI defaults | Source file + localStorage |
| **2 — Local only** | Financial deadlines, dollar amounts, HR contacts, legal dates | `aperture_watch_dates` in localStorage only — use the Deadlines tab in Settings |
| **3 — Never here** | ADA evidence, medical detail, attorney communications, settlement figures | HomeFlow OS canonical files only — this app never touches them |

**Before any commit or push, run:**
```bash
grep -i "severance|salary|hrets|DocuSign|settlement|\$[0-9]" career-builder.html
```
If this returns results outside the guardrail comment block at the top, do not push.

---

## Data Portability

All user data is stored in `localStorage` under `dp_aperture_v1`. This is browser-local — it does not transfer between machines automatically.

**Moving to a new machine:**
1. Old machine: Settings → Data → **Export JSON**
2. New machine: open the app, Settings → Data → **Import JSON**
3. Reload the page

**Keys in use:**
- `dp_aperture_v1` — all main app data (pipeline, contacts, profile, API key)
- `aperture_watch_dates` — Layer 2 deadline entries (managed in Settings → Deadlines)
- `aperture_kpi` — KPI page usage tracking

---

## Pages

| File | Purpose |
|---|---|
| `career-builder.html` | Main app — all seven modes |
| `report.html` | Pipeline funnel + CRM conversion analytics |
| `company-fit.html` | AI-scored company and job fit analysis |
| `kpi.html` | AI usage and cost tracking |
| `netlify/functions/research.js` | Server-side Claude API proxy (keeps API key off client) |
