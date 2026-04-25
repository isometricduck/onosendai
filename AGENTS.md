This is a Flutter client for the Cyberspace social network. It works on both mobile and desktop. It uses Riverpod as a state manager.

All communication with the cyberspace API is handled in the package cyberspace_client.

## App architecture

The code is organized in vertical features with a clean architecture approach:

lib/
├── core/           # theme, router, DI, network, error handling
├── features/
│   ├── feed/
│   │   ├── data/
│   │   │   ├── datasources
│   │   │   ├── models
│   │   │   ├── repositories
│   │   ├── domain/
│   │   │   ├── entities      # Pure Dart classes
│   │   │   ├── repositories  # Abstract interfaces
│   │   │   ├── usecases
│   │   └── presentation/
│   │   │   ├── riverpod
│   │   │   ├── pages
│   │   │   ├── widgets
│   ├── notifications/
│   └── settings/
└── shared/         # shared widgets, utils, extensions


## Adaptive Navigation UI

The app uses a three-variant adaptive navigation layout based on screen width.
All navigation state lives in a single top-level `AppShell` widget.

### Breakpoints

| Variant  | Width         | Navigation component                        |
|----------|---------------|---------------------------------------------|
| Mobile   | < 600dp       | `NavigationBar` (bottom)                    |
| Tablet   | 600 – 840dp   | `NavigationRail`, icons only (`extended: false`) |
| Desktop  | > 840dp       | `NavigationRail` with labels (`extended: true`)  |

### Rules

- Use `MediaQuery.sizeOf(context).width` inside `build()` to determine the active variant. Do not use `LayoutBuilder` for this.
- The three layout variants are separate private widgets: `_MobileShell`, `_TabletShell`, `_DesktopShell`. `AppShell` only selects between them.
- Navigation destinations must be defined once as a `const List` and shared across all three variants.
- Labels are always visible on mobile (`NavigationBar` default). On tablet, hide them (`extended: false`). On desktop, show them (`extended: true`).
- The `NavigationRail` on tablet/desktop is separated from the content area with a `VerticalDivider(width: 1)`.


### AppBar

- **Mobile**: standard `AppBar` in the page scaffold.
- **Tablet/Desktop**: no `AppBar`. Page titles and actions are rendered inline within the content area.

### What not to do

- Do not use the `adaptive_navigation` package.
- Do not share a single `Scaffold` across variants — each shell widget has its own.
- Do not put navigation logic (index state, destination list) inside individual pages.

## Theming

The theme class defines the elements that go into a theme. For the time being, the dark theme is hardcoded.
All icons are taken from the `lucide_icons` package.

## Sections to navigate

### Feed

This is an infinite scroll of posts. Code is under the "feed" feature.
Icon: square-menu

### Write

Create a post.
Icon: square-pen

### Settings

Change settings
Icon: wrench