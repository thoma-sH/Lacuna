# Lacuna — Design System

This file documents the visual language. Code lives in `lib/shared/theme/`.

## Color strategy: Full palette

Three named roles + per-album hue. Each role earns deliberate placement:

| Role | Purpose | Token |
|---|---|---|
| **Accent** | Primary actions, focused state, brand presence | `palette.accent` (+ `accentSoft`, `accentDeep`, `accentGlow`) |
| **Upvote** | Affirmative verdict (post fits the album) | `palette.upvote` |
| **Downvote** | Negative verdict / errors | `palette.downvote` |
| **Album hue** | Per-album context tint — albums each carry their own hue | Set by the album, applied to surfaces inside that album view |

The "one accent ≤10%" rule does **not** apply — Lacuna is full-palette by intent. But each role still has to fight for its spot. Don't paint with all three at once on a single surface.

### OKLCH discipline

When defining new colors:
- Use OKLCH mental model for hue/chroma/lightness reasoning
- Reduce chroma as lightness approaches 0 or 100 (no garish neons at extremes)
- Tint every "neutral" toward the theme's brand hue (chroma 0.005–0.01) — never `#000` or `#fff`. The existing `_calm` palette already does this (`bgDeep: 0xFF06060B` is purple-tinted).

### Album hue

A new concept layered on top of the theme palette. Each album has a single hue (e.g., `0xFFB7A6F0` for "Vibing", `0xFFD17B8E` for "Sunset"). Inside an album view:
- Headers, dividers, and the verdict pill use the album hue
- The grain overlay can pick up the hue at low opacity
- The base theme palette still controls text, backgrounds, and chrome

Album hue is *contextual*, not global. Leaving an album drops back to the theme accent.

## Theme variants

11 named variants in `theme_variants.dart`. **Default is `Calm`** (soft violet dusk, dark) for new installs.

The variants serve as moods the user can choose, not separate brand identities. Curated tier (most on-brand for Lacuna's raw/cozy/nostalgic tone):

- **Calm** — default, dark, soft violet dusk, frosted surfaces
- **Zen** — moss/stone/tea, dark, paper surfaces, serif (Lora)
- **Barbaric** — ember/leather/bone, dark, paper surfaces, serif (Cinzel)
- **Effervescent** — soda pop sunrise, *light*, paper surfaces — the cozy light option
- **White** — pure gallery, *light*, minimal — the quiet option

Allowed but stylistic outliers (offer with a "stylized" badge in the picker):
- **Industrial, Space, Translucent, Glass, Monotone, Rage**

### Light/dark pairing

`themeMode: ThemeMode.system` (currently hard-locked to `dark` — fix that).
- When the user picks a light variant, app follows that variant in light mode
- When they pick a dark variant, app follows in dark mode
- Each variant declares its `palette.brightness`; respect it

## Theme: never default

> Dark vs. light is never a default. Not dark "because tools look cool dark." Not light "to be safe."

Lacuna is a content-display app where user photos and videos are the foreground. **Default to system.** A user posting a sunset photo deserves the dark theme that night-time scrolling implies; a user posting a sketchbook page deserves the light theme that daytime browsing implies.

The scene-sentence test: *"Someone curled on a couch at 10pm flipping through their friend's album of last weekend's road trip."* That sentence forces dark default for first-time users at night and light default for daytime — which is exactly what `ThemeMode.system` provides.

## Typography

**Display: serif. Body: sans.** Lacuna leans on serif display for headings, titles, and the brand-feel surfaces — it's the single biggest signal that Lacuna is not Instagram.

| Use | Family | Notes |
|---|---|---|
| Display + headlines | **Fraunces** (Google Fonts) — variable serif with optical size + soft contrast | The serif display flair |
| Body + labels | Variant's declared `fontName` (Inter for most) | Keep readability where it counts |

Implementation: `AppTypography.build()` should override `display*`, `headline*`, and possibly `titleLarge` with Fraunces; leave body/label on the variant font.

### Scale

Hierarchy through scale + weight contrast. Existing scale in `app_typography.dart` is fine — keep ratio ≥1.25 between steps.

- `displayLarge` 48 / w300 / -1.2 letterspacing → keep, switch to Fraunces
- `displayMedium` 36 / w300 / -0.8 → keep, switch to Fraunces
- `headlineLarge` 24 / w500 / -0.4 → switch to Fraunces w400 (serif doesn't need w500 for weight)
- Body stays as-is

### Constraint

Body line length cap: **65–75ch.** In Flutter, this means wrapping body text columns in `ConstrainedBox(maxWidth: 680)` on tablet/desktop layouts.

## Layout

- **Spacing:** use `AppSpacing` tokens. Vary spacing for rhythm — same padding everywhere is monotony.
- **Cards:** Lacuna already over-uses card containers (see `home_feed_page.dart`). Cards are the lazy answer. Prefer:
  - Full-bleed media tiles for the feed (we already have `immersive_feed_tile.dart` — favor it over the boxed card)
  - Inline content with hairline dividers rather than nested cards
  - Album hue tints on surfaces instead of card borders
- **Containers:** don't wrap everything. Most things don't need a max-width container on phone; do constrain on tablet/desktop.

## Motion

Existing `AppMotion`:
- Use `enter: Curves.easeOutCubic` for entrances — exponential ease-out family is correct
- Avoid layout-property animations (already correct — animations are on opacity/transform)
- `breatheCurve: Curves.easeInOutSine` for the breathing widgets — keep
- No bounce, no elastic — already followed

## Surfaces

Variants declare surface style: `solid | frosted | liquidGlass | paper`. Per Lacuna's tone:
- **Calm / Zen / Barbaric** lean **paper** or **frosted** — texture-forward
- **Glass / Translucent** are the iOS-glass moods — keep but mark as stylized
- The **grain overlay** (`grain_overlay.dart`) is on-brand at 4–8% opacity

## Iconography

- Phosphor (`phosphor_flutter`) is the primary icon set — already in pubspec
- Material icons for Material widgets that don't accept custom icons (e.g., `NavigationDestination` already uses Material icons in `app_shell_page.dart` — switch those to Phosphor for brand consistency)

## Absolute bans

These apply to Lacuna across all variants. Translate the impeccable bans to Flutter:

- ❌ **Side-stripe borders** (`Border(left: BorderSide(...))` >1px as accent) — use full borders, background tints, or leading icons
- ❌ **Gradient text** (`ShaderMask` for decorative gradient on text) — single solid color, emphasize via weight/size
- ❌ **Glassmorphism as default** — only on `Glass` and `Translucent` variants where it's the point
- ❌ **The hero-metric template** (big number, small label, supporting stats, gradient accent — SaaS cliché)
- ❌ **Identical card grids** (same-sized cards with icon + heading + text repeated)
- ❌ **Modals as first thought** — exhaust inline / progressive alternatives before reaching for `showDialog` or `showModalBottomSheet`
- ❌ **Em dashes in copy** — use commas, colons, semicolons, periods, or parentheses

## Copy

- Every word earns its place. No restated headings, no intros that repeat the title.
- Tone matches the product: **raw, cozy, nostalgic.** Avoid corporate or breezy startup-speak ("Welcome aboard!", "Let's get started!", "Awesome!").
- Empty states should feel like a quiet room, not an exhortation.

## AI-slop test

Failures Lacuna must pass:

1. **First-order:** if someone could guess the theme + palette from "social photo app" alone — "Instagram-cream + gradient", "TikTok-neon-on-black" — it's the first reflex. Lacuna's serif-display + dim-violet + paper-grain combination should NOT be the obvious answer.
2. **Second-order:** "anti-Instagram social app" → "minimalist black/white with serif" is the next-tier reflex. Lacuna avoids that by leaning into *warmth* (Calm's violet, Barbaric's ember, Zen's tea) rather than monochromatic restraint.
3. **Category-reflex check:** the unique markers — per-album hue, verdict pill, breathing blob, scalloped avatar, grain overlay — should be visible enough that the app doesn't read as a generic Material 3 social shell.

## Responsive

Per `flutter-build-responsive-layout`:
- `MediaQuery.sizeOf(context)` for window size, never device classification
- `LayoutBuilder` for component-local breakpoints
- Breakpoint: `largeScreenMinWidth = 600` for component-level, `expandedScreenMinWidth = 900` for app-shell-level (sidebar nav vs bottom nav)
- Body text columns capped at 680px on wide screens (`ConstrainedBox` + `Center`)
- Lists become grids on wide screens (`GridView.builder` with `SliverGridDelegateWithMaxCrossAxisExtent`)
- **Never** lock orientation; never check hardware type

## Architecture conventions

Per `flutter-apply-architecture-best-practices`, adapted for Lacuna's existing Bloc/Cubit setup:

- **View** — `StatelessWidget` or `StatefulWidget` with no business logic. Reads state from Cubit via `BlocBuilder` / `context.watch`.
- **Cubit** — the ViewModel. Manages state, exposes commands. Injects Repository via constructor.
- **Repository** — single source of truth for data. Consumes Services. Returns Domain Models. Handles caching, retries, offline.
- **Service** — wraps an external dependency (Supabase client, image picker, etc.). Stateless. Returns raw responses.
- **State classes** use **`freezed`** going forward — immutable, copyWith, equals/hashCode for free.
- **DI** via **`get_it`** at app boot; Cubits resolve their dependencies through it.

## File layout

```
lib/
├── data/             # not used — Lacuna's structure is feature-based
├── features/
│   └── [feature]/
│       ├── data/
│       │   └── repos/        # repository impls
│       ├── domain/
│       │   ├── entities/
│       │   └── repos/        # repository interfaces
│       └── presentation/
│           ├── cubits/
│           ├── pages/
│           └── widgets/
├── shared/
│   ├── theme/
│   ├── widgets/
│   ├── constants/
│   └── utils/
└── app/
```

The hybrid: feature-grouped UI + repos-by-feature. This deviates from the skill's strict "data-by-type, ui-by-feature" but keeps Lacuna's existing convention. Don't churn.
