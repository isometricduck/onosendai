This is a Flutter client for the Cyberspace social network. It works on both mobile and desktop. It uses Riverpod as a state manager.

All communication with the cyberspace API is handled in the package cyberspace_client.

## App architecture

The code is organized in vertical features with a clean architecture approach:

lib/
├── core/           # router, DI, network, error handling
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

The app uses a semantic theme approach. ClassicTheme map these to four colors, where "foreground", "border" and "dimmed" are in the same family and with a strong contrast to "background". FourColorsTheme maps four distinct colors.

All themes use a shader to display images. The classes in @lib/core/images/shaders set the default parameters and the actual shaders live in assets/shaders/

## Tools

Use 'puro flutter' to run any flutter commands.
