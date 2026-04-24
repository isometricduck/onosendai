This is a Flutter client for the Cyberspace social network. It works on both mobile and desktop. It uses Riverpod as a state manager.

All communication with the cyberspace API is handled in the package cyberspace_client.

The code is organized in vertical features with a clean architecture approach:

lib/
├── core/           # theme, router, DI, network, error handling
├── features/
│   ├── feed/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   ├── domain/
│   │   │   ├── entities      # Pure Dart classes
│   │   │   ├── repositories/ # Abstract interfaces
│   │   │   ├── usecases/
│   │   └── presentation/
│   │   │   ├── riverpod
│   │   │   ├── pages
│   │   │   ├── widgets
│   ├── notifications/
│   └── settings/
└── shared/         # shared widgets, utils, extensions
