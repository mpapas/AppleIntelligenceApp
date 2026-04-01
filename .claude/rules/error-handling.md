---
paths:
  - "**/*.swift"
---

# Error Handling & Logging

## Custom Error Types

```swift
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(Int)
    case decodingError(Error)
    case networkFailure(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .invalidResponse: "Invalid server response"
        case .unauthorized: "Session expired. Please log in again."
        case .notFound: "Resource not found"
        case .serverError(let code): "Server error (\(code))"
        case .decodingError: "Failed to process response"
        case .networkFailure: "Network connection failed"
        }
    }
}
```

## Error Propagation

- Services throw errors, views catch and display
- Use `Result` only when you need to store an error state
- Log errors at the point of origin

```swift
// Service
func loadUser() async throws -> User {
    do {
        return try await networkService.request(.user(id: userId))
    } catch {
        logger.error("Failed to load user: \(error)")
        throw error
    }
}

// View
.task {
    do {
        user = try await service.loadUser()
    } catch {
        errorMessage = error.localizedDescription
    }
}
```

## Logging with os.Logger

```swift
extension Logger {
    enum Category: String {
        case network = "Network"
        case service = "Service"
        case ui = "UI"
        case analytics = "Analytics"
    }

    init(category: Category) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "", category: category.rawValue)
    }
}
```

**Log:** Network requests/responses (no sensitive data), state transitions, error conditions, performance operations.

**Do NOT log:** User credentials, tokens, PII, successful routine operations, full response bodies in production.
