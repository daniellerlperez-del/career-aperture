# Career Aperture — Master Architecture Review
**Reviewed:** 2026-05-30  
**Scope:** First-run setup, privacy layers, data architecture, navigation, security

---

## Executive Summary

The system works well as a local personal tool, but has 8 structural gaps that will cause silent failures or privacy exposure on any new system. Four are critical (data loss on new system, broken navigation, no Layer 2 data input UI, API key undocumented). The others are maintenance and security concerns.

---

## Critical Issues

### 1. No Cross-System Data Portability — New System = Fresh Start

**What happens:** All user data lives in `localStorage` under `dp_aperture_v1`. localStorage is browser-local and machine-local. On a new device, new browser, or cleared browser data, everything is gone: pipeline cards, network contacts, saved searches, watch list customizations, API key.

**Impact:** Total loss of all career pipeline state when switching machines.

**Fix needed:**
- Add Export/Import JSON in Settings (one button: "Export my data" → downloads `aperture-backup.json`; one button: "Import data" → loads from file)
- Alternatively: sync to a private GitHub Gist using a PAT — keeps it in git without being in the public repo

---

### 2. No Navigation from Main App to Report / Company Fit / KPI Pages

**What happens:** `grep "report|company-fit|kpi" career-builder.html` → **0 matches**. The three companion pages exist on disk and are in the repo, but the main app sidebar has no links to them. A user on a new system has no way to discover they exist.

**Impact:** report.html, company-fit.html, and kpi.html are effectively invisible.

**Fix needed:** Add a "Reports" section to the main app's sidebar with links to all three pages. Quick to do — three `<a href>` nav buttons.

---

### 3. Layer 2 Data (Watch Dates) Has No Input UI

**What happens:** The `WATCH_DATES` array was rightly moved to `localStorage` key `aperture_watch_dates`, but there is no UI anywhere in the app to add, edit, or delete entries. On any new system, the Watch Dates section is permanently empty with no way to populate it.

**Impact:** The Claims & Benefits page is broken for all new setups.

**Fix needed:** Add a "Manage Watch Dates" panel in Settings (or inline in the Claims page) — simple form: date picker, label, description → saves to `aperture_watch_dates` in localStorage. Include a note: "This data stays local — never synced, never committed."

---

### 4. Netlify API Key Setup Is Undocumented

**What happens:** When deployed to Netlify, AI features (Loupe, Field Work, Reach) require `ANTHROPIC_API_KEY` to be set in Netlify's environment variables. This is not documented anywhere in the README, which currently just says "Single-file React app. Open in browser. No build step."

**Impact:** On any new Netlify deployment, all AI features return `500 - ANTHROPIC_API_KEY not configured` with no guidance.

**Fix needed:** README needs a setup section:
```
## Setup (Netlify)
1. Connect repo to Netlify, set publish directory to `.`
2. Add environment variable: ANTHROPIC_API_KEY = sk-ant-...
3. Branch: `public` → production

## Setup (local / file://)
Open career-builder.html directly. Add your API key in Settings.
```

---

## Moderate Issues

### 5. Default Profile Contains Personal Data in a Public Repo

**What happens:** The `defaultStored` object in career-builder.html contains Danielle's full name, role, background paragraph, and positioning edge — hardcoded in source. Anyone who views the public GitHub repo sees this.

**Severity:** Medium — this is less sensitive than financial data, but it is career-positioning content that belongs to the user, not to the codebase.

**Fix needed:** Move defaults to a first-run setup modal (name, role, domain) that fires when localStorage is empty. Store everything the user enters, never hardcode it. Default to empty fields.

---

### 6. Preview Gate Password Hardcoded → Gone Entirely

**What happens:** The `LensOn.PCL26` preview gate was removed (correctly) from the Desktop version during the luxury brand update. But now the public branch has **no gate at all** — the app opens directly.

**Impact:** If this is a tool you share with mentors or employers via the GitHub Pages URL, there's no friction between them and your live pipeline data.

**Fix needed:** Two options:
- **Option A:** Restore the gate, but read the password from localStorage (set it once in Settings) — never hardcoded in source
- **Option B:** Accept no gate and ensure no sensitive data is ever in the pipeline that you'd mind being seen

---

### 7. KPI Page Uses a Different localStorage Key

**What happens:** `kpi.html` reads from `aperture_kpi`, while the main app writes to `dp_aperture_v1`. They do not share data. The KPI page has its own separate state.

**Impact:** Pipeline data and KPI data are siloed. Report.html correctly reads from `dp_aperture_v1` and gets real pipeline data. KPI reads a separate key and may be empty or stale.

**Fix needed:** Audit kpi.html — decide if it should read from `dp_aperture_v1` like report.html, or if `aperture_kpi` is intentional (for AI call tracking separate from pipeline tracking). Reconcile the keys.

---

### 8. Four HTML Files with Duplicated Design System

**What happens:** career-builder.html, report.html, company-fit.html, and kpi.html each have their own copy of the CSS design tokens (color palette, typography, card styles). The current palette across files is inconsistent:
- career-builder.html + report.html + company-fit.html: luxury noir (`#09080A`, gold `#C9A84C`)
- kpi.html: older violet palette (`#0C0C12`, orange `#F0A820`)

**Impact:** Any palette update requires editing 4 files. Visual inconsistency is already present.

**Fix needed (pragmatic):** Extract design tokens to a shared `aperture-theme.css` file that all pages link. Or accept the duplication and add a comment in each file: `<!-- DESIGN TOKENS: copy from career-builder.html :root block -->`. At minimum, update kpi.html to the luxury noir palette for visual consistency.

---

## First-Run Activation Checklist (What's Missing)

A new system currently has no setup guide. Here's what should exist:

```
FIRST-RUN SETUP
───────────────
□ 1. Open career-builder.html in browser
□ 2. On first run: setup modal fires → enter name, role, target domain
□ 3. Settings → API Key → paste Anthropic key (stays in localStorage, never synced)
□ 4. Settings → Watch Dates → add your financial/legal deadlines (Layer 2 — local only)
□ 5. Develop → add job pipeline cards
□ 6. Contact Sheet → add network contacts
□ 7. Light Table → review company watch list, customize tiers

PRIVACY LAYER REMINDER (each time you edit source):
□ Layer 1: Profile text, job search preferences → OK in source as defaults
□ Layer 2: Dollar amounts, deadlines, HR contacts, case numbers → localStorage only, never source
□ Layer 3: ADA/medical, attorney comms, settlement details → HomeFlow OS canonical files only, never in this app
```

---

## Privacy Layer Architecture Summary

| Layer | What Belongs Here | Where It Lives in This System | Status |
|---|---|---|---|
| 1 — AI-safe | Name, role, domain, watch list company names | Source defaults + localStorage | ✅ OK |
| 2 — Private/local | Financial deadlines, net amounts, HR contacts, legal dates | `aperture_watch_dates` in localStorage | ⚠️ No UI to enter |
| 3 — Attorney Eyes Only | ADA evidence, medical detail, settlement figures, case strategy | HomeFlow OS canonical files only | ✅ App never touches these |

---

## Priority Order for Fixes

| Priority | Issue | Effort |
|---|---|---|
| 🔴 1 | Add Export/Import JSON to Settings | 1–2 hours |
| 🔴 2 | Add report/company-fit/kpi links to main sidebar | 20 min |
| 🔴 3 | Add Watch Dates management UI in Settings | 1 hour |
| 🔴 4 | Write README setup section for Netlify + local | 20 min |
| 🟡 5 | Move default profile to first-run setup modal | 2 hours |
| 🟡 6 | Restore configurable preview gate | 1 hour |
| 🟡 7 | Reconcile KPI localStorage key | 30 min |
| 🟢 8 | Align kpi.html to luxury noir palette | 1 hour |
