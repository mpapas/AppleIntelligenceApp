# iOS Swift Project — AppleIntelligenceApp

This is an **iOS project** built with **Swift** and **SwiftUI**.

## Tech Stack

- **Language:** Swift 6 (strict concurrency enabled)
- **UI Framework:** SwiftUI only (no UIKit, no Storyboards, no XIBs)
- **Architecture:** MVVM-lite with `@Observable` Services
- **Dependency Injection:** `@Environment()` in SwiftUI
- **Networking:** Native `URLSession` with protocol-based wrapper
- **Testing:** Swift Testing (`import Testing`) for unit tests, XCTest for UI tests
- **Package Manager:** Swift Package Manager (SPM) exclusively
- **Linting:** SwiftLint
- **CI/CD:** Xcode Cloud → TestFlight

## Project Structure

```
/AppleIntelligenceApp/
├── App/                          # App entry point, app delegate
├── Models/                       # Domain models, DTOs
│   └── {Domain}/                 # Grouped by domain
├── Services/                     # Business logic (@Observable services)
│   ├── {Domain}/                 # Domain-specific services
│   └── Network/                  # Networking layer
├── Views/                        # UI components
│   ├── {Feature}/                # Feature-specific views
│   ├── Components/               # Reusable UI components
│   └── Modifiers/                # Custom ViewModifiers
├── Extensions/                   # Organized by framework
│   ├── Foundation/
│   ├── SwiftUI/
│   └── {Framework}/
├── Styles/                       # Custom ButtonStyles, etc.
├── Resources/                    # Assets, configs, certificates
│   ├── Assets.xcassets
│   └── Configurations/           # Per-environment configs
└── Tests/
    ├── Unit/
    └── UI/
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Service | `{Name}Service.swift` | `AuthenticationService.swift` |
| View | `{Name}View.swift` | `ProfileView.swift` |
| Model | `{Name}.swift` | `User.swift` |
| Extension | `{Type}+{Feature}.swift` | `String+Validation.swift` |
| Modifier | `{Name}Modifier.swift` | `ShimmerModifier.swift` |
| Style | `{Name}Style.swift` | `PrimaryButtonStyle.swift` |
| Protocol | `{Name}Protocol.swift` | `NetworkServiceProtocol.swift` |

- **Types:** `PascalCase`
- **Properties/Methods:** `camelCase`
- **Constants:** `camelCase` (not `SCREAMING_CASE`)

## Dependencies Policy

Prefer native solutions. Before adding a dependency, verify it's necessary, maintained, lightweight, and license-compatible (MIT/Apache 2.0).

| Purpose | Approach |
|---------|----------|
| Networking | Native `URLSession` + custom wrapper |
| JSON | Native `Codable` |
| Images | Native + custom caching if needed |
| Keychain | Custom wrapper over Security framework |
| Analytics | Firebase Analytics |
| Crash Reporting | Firebase Crashlytics |
| Linting | SwiftLint |

## Build & Test

- **Scheme:** `AppleIntelligenceApp`
- **Build:** `xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build`
- **Test:** `xcodebuild test -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'`
- Check scheme configuration with `xcodebuild -list -project AppleIntelligenceApp.xcodeproj` before running tests
- Minimum 50% coverage on business logic (services, models with logic, utilities)

## Project Context

- **Base Branch:** `main`
- **Bundle ID:** `com.example.lextech.AppleIntelligenceApp`

## Detailed Rules

See `.claude/rules/` for detailed conventions on:
- Architecture (MVVM-lite, services, DI)
- Swift 6 concurrency (Sendable, actors, async/await)
- UI development (SwiftUI composition, modifiers, previews)
- Networking (protocol-based, type-safe endpoints)
- Error handling (custom errors, logging)
- Testing (coverage, structure, naming)
- Forbidden patterns (force unwrap, singletons, etc.)
