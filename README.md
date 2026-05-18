# Lacuna

> The void is the point.

Lacuna is a Flutter social app organized around **albums** — user-defined themed collections of photos and videos. The community votes on whether a post *fits the album* (curatorial signal), not on whether they personally like it. See `PRODUCT.md` for the product brief and `DESIGN.md` for visual direction.

## Stack

- Flutter (stable channel, currently 3.41.6) with `flutter_bloc`
- Supabase (auth, Postgres, Storage) — RLS-first
- Sentry for crash + performance, gated behind `SENTRY_DSN`
- Flame + Forge2D for the in-app *Friend or Foe* game

## Local setup

```bash
flutter pub get
cp .env.example .env   # then fill in real values
flutter run
```

`.env` is loaded as a Flutter asset and must contain at minimum:

```
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=<anon-key>
SENTRY_DSN=                # optional; leave blank to disable crash reporting
```

The file is gitignored — never commit it.

## Tests

```bash
flutter analyze
flutter test
```

CI runs both on every push to `main` and on PRs (`.github/workflows/ci.yaml`).

## Release builds

### Android

Release signing reads from `android/key.properties` (gitignored). Copy `android/key.properties.example` and fill in real values. To generate an upload keystore:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then:

```bash
flutter build appbundle --release
```

If `key.properties` is absent, the release build falls back to debug signing so `flutter run --release` still works locally — but a debug-signed bundle cannot be uploaded to Play Console.

Application id: `com.lacuna.app`.

### iOS

Bundle identifier: `com.lacuna.app`. Configure signing in Xcode (`ios/Runner.xcworkspace`) under the Runner target before archiving.

```bash
flutter build ipa --release
```

## Repo layout

```
lib/
  app/         # root widget, routing
  features/    # auth, feed, post, profile, explore, search, activity,
               # moderation, settings, home, game
  shared/      # theme, widgets, utils, constants
supabase/      # migrations + RLS audit scripts
test/          # widget + unit tests
```

Internal/legacy code may still use `blob` — the user-facing term is **album**.
