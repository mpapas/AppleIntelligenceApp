---
paths:
  - "**/*.swift"
---

# Architecture — MVVM-lite with @Observable Services

## Pattern

```
View <-> Service (acts as ViewModel) <-> Repository/Network
```

- **Services own business logic** — Views are dumb, services are smart
- **Protocol-first design** — Abstract dependencies behind protocols for testability
- **Environment-based DI** — Inject services via `@Environment()` in SwiftUI
- **No singletons** — Always use dependency injection

## Service Structure

Every service follows this template:

```swift
@Observable
class FeatureService {
    // MARK: - Dependencies (injected)
    private let networkService: NetworkServiceProtocol

    // MARK: - Published State
    @MainActor private(set) var isLoading = false
    private(set) var items: [Item] = []

    // MARK: - User Input
    var searchText = ""

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Public Methods
    func loadItems() async { }

    // MARK: - Private Methods
    private func processItems() { }
}
```

## Key Rules

- Views NEVER contain business logic — delegate to services
- Services are injected via `@Environment`, never created inside views
- All dependencies come through `init` — never create them internally
- Use protocols for all injectable dependencies
- `.sample` static property on all models and services for previews
