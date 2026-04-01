---
paths:
  - "**/Services/Network/**/*.swift"
  - "**/Network/**/*.swift"
---

# Networking

## Protocol-Based Design

```swift
protocol NetworkServiceProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func download(_ url: URL, to destination: URL) async throws
}
```

Implementations:
- `NetworkServiceOnline` — Real API calls
- `NetworkServiceLocal` — Mock data for previews/tests

## Type-Safe Endpoints

```swift
enum Endpoint {
    case users
    case user(id: String)
    case createUser(CreateUserRequest)

    var path: String {
        switch self {
        case .users: "/users"
        case .user(let id): "/users/\(id)"
        case .createUser: "/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .users, .user: .get
        case .createUser: .post
        }
    }

    var body: Encodable? {
        switch self {
        case .createUser(let request): request
        default: nil
        }
    }
}
```

## Request Flow

```swift
func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
    let request = try buildRequest(for: endpoint)
    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }

    switch httpResponse.statusCode {
    case 200..<300:
        return try decoder.decode(T.self, from: data)
    case 401:
        throw NetworkError.unauthorized
    case 404:
        throw NetworkError.notFound
    default:
        throw NetworkError.serverError(httpResponse.statusCode)
    }
}
```

## Environment Configuration

Use separate configurations per environment:
```
/Configurations/
├── Test/Configuration.json
├── Certification/Configuration.json
└── Production/Configuration.json
```
