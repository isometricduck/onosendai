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


### AppBar

- **Mobile**: standard `AppBar` in the page scaffold. Only the first 5 destinations get icopns in the nav bar.
- **Tablet/Desktop**: no `AppBar`. Page titles and actions are rendered inline within the content area.

## Theming

The theme class defines the elements that go into a theme. For the time being, the dark theme is hardcoded.
All icons are taken from the `lucide_icons` package.

## Tools

Use 'fvm flutter' to run any flutter commands.
