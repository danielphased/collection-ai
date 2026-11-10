---
name: color-system
description: Turn a palette into a working UI colour system — give each colour one role, apply the 60/30/10 split, check WCAG contrast with the bundled script and store everything as CSS variables. Use when choosing or applying brand colours, when a UI looks flat or noisy, when picking an accent or call-to-action colour, when building a dark or light theme, or when text contrast needs checking.
version: 1.0.0
---

# Colour system

A palette is not a design until every colour has a job. Most "AI-looking"
interfaces fail here: too many accents, low-contrast text, colours typed as
raw hex all over the code.

Project-specific rules (brand colours, design tokens, Tailwind theme) belong in the project's own CLAUDE.md or design system — follow them when present.

## 1. Start from what exists

Look for brand colours before proposing any: the logo, an existing
`:root` block, a Tailwind theme, a `design.md`, a tokens file. Build around
the brand colour; do not replace it. Never copy hex values from a screenshot
or a video without checking them.

## 2. Give each colour one role

| Role | Token | Used for |
|---|---|---|
| Background | `--bg` | The page itself |
| Surface | `--surface` | Cards, panels, inputs |
| Text | `--text` | Body text on background and surface |
| Muted text | `--text-muted` | Secondary text, placeholders |
| Border | `--border` | Dividers, outlines |
| Primary | `--primary` | Brand colour: links, selected states |
| Accent | `--accent` | The one action you want clicked |
| Feedback | `--success`, `--warning`, `--danger` | Status only, never decoration |

## 3. Apply 60 / 30 / 10

- **60%** neutrals: background and surfaces.
- **30%** the main colour: headers, primary areas, text colour or brand blocks.
- **10%** the loud colour: the main call to action and a few highlights.

The 10% decides how the whole page feels, so keep the 60 and 30 fixed and
compare two or three accents on the same screen. Use the accent in one or two
places per screen; if everything is loud, nothing is.

## 4. Check contrast

Run the bundled script on every text/background pair, and on the accent with
its button text:

```sh
python3 scripts/contrast.py '#14161a' '#ffffff'            # one pair
python3 scripts/contrast.py --pairs 'bg=#ffffff' 'text=#14161a' 'accent=#c2410c'   # every combination
```

| Use | Minimum ratio (WCAG AA) |
|---|---|
| Body text | 4.5 : 1 |
| Large text (24px+, or 18.66px+ bold) | 3 : 1 |
| Icons, input borders, focus rings | 3 : 1 |

Fix failures by changing lightness, not by shrinking the text or adding
opacity. Do not rely on colour alone to carry meaning (pair status colours
with an icon or a word).

## 5. Store the colours once

```css
:root {
  --bg: #ffffff;
  --surface: #f6f7f9;
  --text: #14161a;
  --text-muted: #5b6270;
  --border: #dfe3e8;
  --primary: #1f4fd8;
  --accent: #c2410c;
}

:root[data-theme="dark"] {
  --bg: #0f1216;
  --surface: #181c22;
  --text: #eef0f3;
  --text-muted: #a3aab6;
  --border: #2a303a;
  --primary: #7aa2ff;
  --accent: #ff8a4c;
}

body { background: var(--bg); color: var(--text); }
.card { background: var(--surface); border: 1px solid var(--border); }
a { color: var(--primary); }
.button-primary { background: var(--accent); color: var(--bg); }
```

The values above are a neutral placeholder: replace them with the project's
own colours and re-run the contrast check. Use only the token names in
component styles, so one change updates the whole product. A dark theme is a
second set of values for the same roles, checked for contrast separately; it
is not the light theme inverted.

## 6. Decide the accent with data

When two accents both pass contrast, run an A/B test on the main button and
compare clicks. Opinions about which looks better are usually wrong.

## Done when

- every colour in the UI maps to a token with one role;
- no raw hex values remain in component styles;
- every text and control pair passes the table above in each theme;
- the accent appears only where an action is wanted.
