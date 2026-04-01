---
paths:
  - "**/Views/**/*.swift"
  - "**/Components/**/*.swift"
  - "**/Modifiers/**/*.swift"
  - "**/Styles/**/*.swift"
---

# UI Development — SwiftUI

## Framework

**SwiftUI only.** No UIKit, no Storyboards, no XIBs. UIKit bridging only when absolutely necessary (e.g., PDFKit, complex gestures).

## View Composition

- Extract subviews when a view exceeds ~50 lines
- Use `@ViewBuilder` for conditional content
- Prefer computed properties over inline logic

```swift
struct FeatureView: View {
    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            loadingView
        } else {
            dataView
        }
    }

    private var loadingView: some View { ... }
    private var dataView: some View { ... }
}
```

## Custom Modifiers

Encapsulate reusable view logic as `ViewModifier`:

```swift
struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay { if isLoading { ProgressView() } }
            .disabled(isLoading)
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
```

## Previews

Every view MUST have a `#Preview` with sample data:

```swift
#Preview {
    FeatureView()
        .environment(FeatureService.sample)
}
```

Implement `.sample` on all models and services:

```swift
extension User {
    static var sample: User {
        User(id: "1", name: "John Doe", email: "john@example.com")
    }
}
```

## State Management

| Scope | Tool |
|-------|------|
| View-local | `@State` |
| View input | `let` / `Binding` |
| Shared state | `@Observable` service via `@Environment` |
| Persistent | `@AppStorage` / File storage |

## Loading State Pattern

Use `LoadingState<T>` for views that load async data:

```swift
enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}
```

Apply in views with pattern matching:

```swift
@ViewBuilder
private var content: some View {
    switch service.state {
    case .idle:
        EmptyView()
    case .loading:
        ProgressView()
    case .loaded(let data):
        DataView(data: data)
    case .failed(let error):
        ErrorView(error: error)
    }
}
```
