---
paths:
  - "**/Tests/**/*.swift"
  - "**/*Tests.swift"
  - "**/*Test.swift"
---

# Testing

## Coverage Target

**Minimum 50% coverage on business logic** (services, models with logic, utilities).

## Priority

1. **Unit tests** — Services, business logic, utilities
2. **UI tests** — Critical user flows only

## Framework

- **Unit tests:** Swift Testing (`import Testing`) for all new tests
- **UI tests:** XCTest (`import XCTest`) — `XCUIApplication` requires XCTest infrastructure

Do NOT use XCTest for unit tests. Do NOT use Swift Testing for UI tests.

## Unit Test Structure

```swift
import Testing
@testable import AppleIntelligenceApp

struct UserServiceTests {
    let sut: UserService
    let mockNetwork: MockNetworkService

    init() {
        mockNetwork = MockNetworkService()
        sut = UserService(networkService: mockNetwork)
    }

    @Test
    func test_loadUser_success_returnsUser() async throws {
        // Given
        mockNetwork.mockResponse = User.sample

        // When
        let user = try await sut.loadUser(id: "123")

        // Then
        #expect(user.id == "123")
    }

    @Test
    func test_loadUser_networkError_throws() async {
        // Given
        mockNetwork.mockError = NetworkError.networkFailure(URLError(.notConnectedToInternet))

        // When/Then
        await #expect(throws: NetworkError.self) {
            try await sut.loadUser(id: "123")
        }
    }
}
```

## UI Test Structure

```swift
import XCTest

final class LoginUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_login_validCredentials_showsHome() throws {
        // Given
        let emailField = app.textFields["email"]
        let passwordField = app.secureTextFields["password"]

        // When
        emailField.tap()
        emailField.typeText("user@example.com")
        passwordField.tap()
        passwordField.typeText("password123")
        app.buttons["Sign In"].tap()

        // Then
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 5))
    }
}
```

## Naming Convention

```
test_{method}_{scenario}_{expected}
```

Examples:
- `test_loadUser_success_returnsUser`
- `test_validate_emptyEmail_returnsFalse`
- `test_calculate_negativeInput_throws`

## Key Rules

- Follow **Given/When/Then** pattern
- Each test is independent — no shared mutable state between tests
- Use `sut` (system under test) for the object being tested
- Use mock implementations via protocols
- Test public interface only — not private methods
- Tests must be meaningful — not just coverage padding
