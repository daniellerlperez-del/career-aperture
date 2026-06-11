# Career Aperture: Version Comparison & Merge Strategy

## File Size
- **Lux Noir (5f68fb8)**: 5,442 lines
- **Current (HEAD)**: 5,992 lines
- **Difference**: +550 lines of new functionality

---

## KEY DIFFERENCES TO MERGE

### 🎨 DESIGN & AESTHETICS (Lux Noir → Restore)

#### Typography
- **Lost**: `Cormorant Garamond` - elegant serif font for luxury noir aesthetic
- **Action**: RESTORE Cormorant Garamond import from Google Fonts
  ```diff
  - <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
  + <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400;1,500&display=swap" rel="stylesheet" />
  ```

#### Custom Camera Cursor (Photography Metaphor)
- **Lost**: Entire custom cursor system with camera/shutter animation
- **Includes**: 
  - SVG-based camera reticle cursor
  - Shutter animation on interaction
  - "Thinking" state with rotating aperture ticks
  - Smooth opacity transitions
- **Action**: RESTORE all camera cursor styles & animations
  ```css
  /* Custom Camera Cursor */
  html,body,*{cursor:none!important}
  #cur-outer{position:fixed;pointer-events:none;z-index:99999;...}
  /* 40+ lines of cursor animation */
  ```

#### Shutter Transition
- **Lost**: Page shutter/flash transition effect on navigation
- **Action**: RESTORE shutter opacity transition
  ```css
  .main{transition:opacity 0.07s ease-in-out}
  .main.shutter{opacity:0}
  ```

#### Color Accent Scheme
- **Lux Noir**: `rgba(240,168,32,...)` - warm golden/orange accent (more cinematic)
- **Current**: `rgba(201,168,76,...)` - muted pale gold
- **Action**: EVALUATE - lux noir color is more dramatic and photographic
  - Consider reverting to lux noir's warmer gold `#F0A820` base
  - This affects 40+ color properties throughout

#### Logo Gradient
- **Lux Noir**: `linear-gradient(90deg,#3D1A88,#8B2BBE,#D01878,#E86020,#C9A84C)` - full spectrum
- **Current**: `linear-gradient(90deg,#B07AE8,#E84CA0,#C9A84C)` - simplified
- **Action**: RESTORE full spectrum gradient for richer visual

---

### ⚙️ NEW FEATURES (Current → Keep)

#### 1. Meta Tags & SEO
- **Added**: Comprehensive Open Graph tags
  ```html
  <meta name="description" content="Career Aperture — AI-powered career intelligence for job seekers and SMB prospecting. A Perez Creative Labs product." />
  <meta property="og:title" content="Career Aperture — Career Intelligence" />
  <meta property="og:description" content="Your background is the intelligence. Set your context once — every search, brief, and outreach runs on it." />
  <meta property="og:type" content="website" />
  ```
- **Action**: KEEP - essential for social sharing & SEO

#### 2. Google Sign-In Integration
- **Added**: `<script src="https://accounts.google.com/gsi/client" async defer></script>`
- **Action**: KEEP - likely used for authentication/sign-in flow

#### 3. Mobile Responsive Layout
- **Added**: `@media (max-width: 768px)` queries
- **Action**: KEEP - critical for mobile users

#### 4. Enhanced Button Styles
- **Current has**: Simplified primary button gradient vs lux noir's full spectrum
- **Current hover state**: Interactive gradient shift
- **Action**: Consider restoring lux noir's richer gradient while keeping hover interaction

#### 5. New JavaScript Functionality
- **~550 lines** of new JS (likely UI/interaction enhancements)
- **Estimated sections**: Calendar, form handling, new page features
- **Action**: KEEP all new JavaScript

---

## MERGE STRATEGY (Recommended)

### Phase 1: Restore Design Identity
1. ✅ Restore **Cormorant Garamond** font
2. ✅ Restore **custom camera cursor** system + animations
3. ✅ Restore **shutter transition** effect
4. ✅ Evaluate color accent: revert to warmer `rgba(240,168,32,...)` or hybrid
5. ✅ Restore **full spectrum logo gradient**

### Phase 2: Keep Modern Features
6. ✅ KEEP all SEO meta tags
7. ✅ KEEP Google Sign-In integration
8. ✅ KEEP mobile responsive design
9. ✅ KEEP all new JavaScript functionality (550+ lines)
10. ✅ KEEP button hover interactions

### Phase 3: Unified Implementation
11. Search HTML for camera cursor references → ensure properly wired
12. Verify shutter transition JS hooks exist in new code
13. Test responsive design with lux noir typography
14. Ensure camera cursor works with new mobile layout

---

## CRITICAL MERGE CONFLICTS TO WATCH

1. **Color values**: 40+ instances of `rgba(201,168,76,...)` → consider lux noir's `rgba(240,168,32,...)`
2. **Font declarations**: May need both Cormorant Garamond weights + JetBrains Mono
3. **Cursor system**: Check if new JS has any cursor handling that conflicts
4. **Media queries**: Ensure lux noir styles cascade properly at mobile breakpoints
5. **Animation timing**: Shutter + camera cursor timing with new transition features

---

## Expected Result: UNIFIED VERSION

- **Typography**: Georgia serif + Cormorant Garamond (luxury headings) + JetBrains Mono (technical)
- **Aesthetics**: Black & gold lux noir with photography metaphors (camera cursor, shutter flash)
- **Features**: All current enhancements (Google Sign-In, meta tags, mobile, new JS)
- **Size**: ~6,000-6,050 lines (lux noir base + new features)

