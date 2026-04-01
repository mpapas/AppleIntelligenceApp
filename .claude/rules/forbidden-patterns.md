---
paths:
  - "**/*.swift"
---

# Forbidden Patterns

These patterns MUST be avoided. They will be rejected in code review.

## Force Unwrap

```swift
// NEVER
let user = users.first!
let url = URL(string: urlString)!

// ALWAYS
guard let user = users.first else { return }
guard let url = URL(string: urlString) else { throw URLError.invalidURL }
```

## Singletons

```swift
// NEVER
class UserService {
    static let shared = UserService()
}

// ALWAYS — Inject dependencies
class UserService {
    init(networkService: NetworkServiceProtocol) { }
}
```

## Implicit Dependencies

```swift
// NEVER — Hidden dependency
class OrderService {
    func placeOrder() {
        let network = NetworkService() // Created internally
    }
}

// ALWAYS — Explicit dependency
class OrderService {
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}
```

## Business Logic in Views

```swift
// NEVER
struct CheckoutView: View {
    var body: some View {
        Button("Pay") {
            // 50 lines of payment logic
        }
    }
}

// ALWAYS — Delegate to service
struct CheckoutView: View {
    @Environment(CheckoutService.self) var service
    var body: some View {
        Button("Pay") {
            Task { await service.processPayment() }
        }
    }
}
```

## Stringly-Typed Code

```swift
// NEVER
UserDefaults.standard.set(true, forKey: "isLoggedIn")

// ALWAYS — Type-safe
extension UserDefaults.Keys {
    static let isLoggedIn = "isLoggedIn"
}
```

## Nested Callbacks

```swift
// NEVER — Use async/await instead
fetchUser { user in
    fetchOrders(for: user) { orders in ... }
}

// ALWAYS
let user = try await fetchUser()
let orders = try await fetchOrders(for: user)
```

## Other Forbidden Patterns

- **God Classes** — 300+ lines triggers a warning, 500+ lines triggers an error (per SwiftLint). Split proactively.
- **Magic Numbers/Strings** — Use `Constants` enum or named values
- **Commented-out code** — Delete it, git has history
- **`print()` statements** — Use `os.Logger` instead
- **UIKit** — SwiftUI only (unless absolutely necessary)
- **CocoaPods/Carthage** — SPM exclusively
