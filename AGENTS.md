This is a Flutter client for the Cyberspace social network. It works on both mobile and desktop. It uses Riverpod as a state manager.

All communication with the cyberspace API is handled in the package cyberspace_client.

The code is organized in vertical features:

lib/
├── core/           # theme, router, DI, network, error handling
├── features/
│   ├── feed/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── notifications/
│   └── settings/
└── shared/         # shared widgets, utils, extensions

The architecture is divided in these layers:

. Presentation layer
. Domain layer (pure Dart)
. Data layer