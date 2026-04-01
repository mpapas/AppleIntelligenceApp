---
paths:
  - "**/*.swift"
---

# Swift 6 Strict Concurrency

## Strict Concurrency Mode

All projects MUST enable strict concurrency checking:

```
SWIFT_STRICT_CONCURRENCY = complete
```

Or in `Package.swift`:
```swift
swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
```

## Sendable

Types that cross actor boundaries must conform to `Sendable`:
- Value types (structs, enums) are implicitly Sendable
- Immutable `final class` can be Sendable
- Actors are implicitly Sendable
- Mutable classes are NOT Sendable
- Use `@unchecked Sendable` only when you guarantee thread safety through locks

## MainActor Isolation

Apply `@MainActor` to individual properties that the UI observes, not the entire class:
```swift
@MainActor private(set) var isLoading = false
```

## Actor Isolation

- Use `nonisolated` for methods that don't access actor state
- Use `nonisolated(unsafe)` only for legacy code migration — avoid in new code

## @Bindable for Observable

Use `@Bindable` to create bindings from `@Observable` objects:
```swift
struct LoginView: View {
    @Bindable var form: FormService

    var body: some View {
        TextField("Email", text: $form.email)
    }
}
```

For services from `@Environment`, create local bindable:
```swift
@Environment(SettingsService.self) var settings

var body: some View {
    @Bindable var settings = settings
    Toggle("Dark mode", isOn: $settings.darkModeEnabled)
}
```

## Task Cancellation

Always handle cancellation for long-running operations:
- Use `try Task.checkCancellation()` in loops
- Use `defer` for cleanup on cancellation
- Use `withTaskCancellationHandler` for immediate response

## TaskGroup for Dynamic Parallelism

Use `withThrowingTaskGroup` when the number of parallel tasks is dynamic.
Use `group.cancelAll()` on first failure for fail-fast behavior.

## Structured Concurrency

Use `async let` for parallel operations with known count:
```swift
async let user = loadUser()
async let orders = loadOrders()
return Dashboard(user: try await user, orders: try await orders)
```

## Modern Swift Syntax

- Use if/switch expressions for assignments
- Use `consuming` parameter for ownership transfer (performance)
- Use `borrowing` parameter for read-only access without copy

## Migration to Swift 6

1. Enable warnings first: `SWIFT_STRICT_CONCURRENCY = targeted`
2. Fix warnings incrementally (focus on `Sendable` conformance)
3. Mark legacy code: `@preconcurrency import LegacyFramework`
4. Enable complete mode once warnings are resolved
