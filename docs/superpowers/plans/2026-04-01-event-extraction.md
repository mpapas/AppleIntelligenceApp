# Smart Event Extraction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Parse natural language event descriptions into structured event cards using Apple's on-device Foundation Models framework.

**Architecture:** Single-view with `@Generable` structured output. `EventExtractionService` wraps `LanguageModelSession`, checks availability, and produces typed `ExtractedEvent` results. Views consume the service directly via `@State`.

**Tech Stack:** Swift, SwiftUI, FoundationModels framework (`@Generable`, `@Guide`, `LanguageModelSession`, `SystemLanguageModel`), iOS 26+ / macOS 26+

**Spec:** `docs/superpowers/specs/2026-04-01-event-extraction-design.md`

---

## File Structure

| File | Action | Responsibility |
|------|--------|---------------|
| `AppleIntelligenceApp/Models/ExtractedEvent.swift` | Create | `@Generable` struct with `@Guide` annotations |
| `AppleIntelligenceApp/Services/EventExtractionService.swift` | Create | `@Observable` service wrapping `LanguageModelSession` |
| `AppleIntelligenceApp/Views/EventCardView.swift` | Create | Card displaying extracted event fields |
| `AppleIntelligenceApp/Views/EventExtractionView.swift` | Create | Main screen with text input and results |
| `AppleIntelligenceApp/AppleIntelligenceAppApp.swift` | Modify | Point root view to `EventExtractionView` |
| `AppleIntelligenceApp/ContentView.swift` | Delete | Replaced by `EventExtractionView` |

---

### Task 1: ExtractedEvent Model

**Files:**
- Create: `AppleIntelligenceApp/Models/ExtractedEvent.swift`

- [ ] **Step 1: Create the Models directory**

Run:
```bash
mkdir -p AppleIntelligenceApp/Models
```

- [ ] **Step 2: Write ExtractedEvent.swift**

```swift
import FoundationModels

@Generable
struct ExtractedEvent {
    @Guide(description: "People attending the event.")
    var attendees: [String]

    @Guide(description: "Date and time of the event as mentioned in the input.")
    var dateTime: String

    @Guide(description: "Location or venue of the event.")
    var location: String

    @Guide(description: "Topic or purpose of the event.")
    var topic: String
}

extension ExtractedEvent {
    static var sample: ExtractedEvent {
        ExtractedEvent(
            attendees: ["Sarah"],
            dateTime: "Next Friday at noon",
            location: "Café Roma",
            topic: "Discuss the rebrand"
        )
    }
}
```

- [ ] **Step 3: Add file to Xcode project and verify it compiles**

Run:
```bash
xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -5
```
Expected: `BUILD SUCCEEDED`

- [ ] **Step 4: Commit**

```bash
git add AppleIntelligenceApp/Models/ExtractedEvent.swift
git commit -m "feat: add ExtractedEvent @Generable model"
```

---

### Task 2: EventExtractionService

**Files:**
- Create: `AppleIntelligenceApp/Services/EventExtractionService.swift`

- [ ] **Step 1: Create the Services directory**

Run:
```bash
mkdir -p AppleIntelligenceApp/Services
```

- [ ] **Step 2: Write EventExtractionService.swift**

```swift
import Foundation
import FoundationModels
import Observation
import os

@Observable
class EventExtractionService {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "AppleIntelligenceApp",
        category: "EventExtraction"
    )

    @MainActor private(set) var isExtracting = false
    private(set) var extractedEvent: ExtractedEvent?
    private(set) var errorMessage: String?

    var modelAvailability: SystemLanguageModel.Availability {
        SystemLanguageModel.default.availability
    }

    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }

    @MainActor
    func extractEvent(from text: String) async {
        isExtracting = true
        extractedEvent = nil
        errorMessage = nil
        defer { isExtracting = false }

        let session = LanguageModelSession(
            instructions: """
                You are an event parser. Extract structured event details from natural language input.
                Extract attendees, date/time, location, and topic.
                If a field is not mentioned, use "Not specified".
                """
        )

        do {
            let response = try await session.respond(
                to: text,
                generating: ExtractedEvent.self
            )
            extractedEvent = response.content
        } catch {
            logger.error("Event extraction failed: \(error)")
            errorMessage = "Failed to extract event details. Please try again."
        }
    }
}

extension EventExtractionService {
    static var sample: EventExtractionService {
        let service = EventExtractionService()
        service.extractedEvent = ExtractedEvent.sample
        return service
    }
}
```

- [ ] **Step 3: Add file to Xcode project and verify it compiles**

Run:
```bash
xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -5
```
Expected: `BUILD SUCCEEDED`

- [ ] **Step 4: Commit**

```bash
git add AppleIntelligenceApp/Services/EventExtractionService.swift
git commit -m "feat: add EventExtractionService with LanguageModelSession"
```

---

### Task 3: EventCardView

**Files:**
- Create: `AppleIntelligenceApp/Views/EventCardView.swift`

- [ ] **Step 1: Create the Views directory**

Run:
```bash
mkdir -p AppleIntelligenceApp/Views
```

- [ ] **Step 2: Write EventCardView.swift**

```swift
import SwiftUI

struct EventCardView: View {
    let event: ExtractedEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            row(icon: "person.2", label: "Attendees", value: event.attendees.joined(separator: ", "))
            Divider()
            row(icon: "calendar", label: "Date & Time", value: event.dateTime)
            Divider()
            row(icon: "mappin.and.ellipse", label: "Location", value: event.location)
            Divider()
            row(icon: "text.quote", label: "Topic", value: event.topic)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func row(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}

#Preview {
    EventCardView(event: .sample)
        .padding()
}
```

- [ ] **Step 3: Add file to Xcode project and verify it compiles**

Run:
```bash
xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -5
```
Expected: `BUILD SUCCEEDED`

- [ ] **Step 4: Commit**

```bash
git add AppleIntelligenceApp/Views/EventCardView.swift
git commit -m "feat: add EventCardView for displaying extracted events"
```

---

### Task 4: EventExtractionView

**Files:**
- Create: `AppleIntelligenceApp/Views/EventExtractionView.swift`

- [ ] **Step 1: Write EventExtractionView.swift**

```swift
import SwiftUI
import FoundationModels

struct EventExtractionView: View {
    @State private var service = EventExtractionService()
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Event Extractor")
        }
    }

    @ViewBuilder
    private var content: some View {
        if service.isAvailable {
            extractionView
        } else {
            unavailableView
        }
    }

    private var extractionView: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Describe your event...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)

                Button {
                    Task { await service.extractEvent(from: inputText) }
                } label: {
                    Label("Extract Event", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || service.isExtracting)

                if service.isExtracting {
                    ProgressView("Extracting event details...")
                }

                if let event = service.extractedEvent {
                    EventCardView(event: event)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let error = service.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
            }
            .padding()
            .animation(.default, value: service.extractedEvent != nil)
        }
    }

    @ViewBuilder
    private var unavailableView: some View {
        switch SystemLanguageModel.default.availability {
        case .available:
            EmptyView()
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                ContentUnavailableView(
                    "Device Not Supported",
                    systemImage: "iphone.slash",
                    description: Text("This device doesn't support on-device AI models.")
                )
            case .appleIntelligenceNotEnabled:
                ContentUnavailableView(
                    "Apple Intelligence Disabled",
                    systemImage: "brain",
                    description: Text("Enable Apple Intelligence in Settings > Apple Intelligence & Siri.")
                )
            case .modelNotReady:
                ContentUnavailableView(
                    "Model Preparing",
                    systemImage: "arrow.down.circle",
                    description: Text("The AI model is downloading. Please try again shortly.")
                )
            @unknown default:
                ContentUnavailableView(
                    "Unavailable",
                    systemImage: "exclamationmark.triangle",
                    description: Text("On-device AI is not available.")
                )
            }
        }
    }
}

#Preview {
    EventExtractionView()
}
```

- [ ] **Step 2: Add file to Xcode project and verify it compiles**

Run:
```bash
xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -5
```
Expected: `BUILD SUCCEEDED`

- [ ] **Step 3: Commit**

```bash
git add AppleIntelligenceApp/Views/EventExtractionView.swift
git commit -m "feat: add EventExtractionView with input and availability handling"
```

---

### Task 5: Wire Up App Entry Point

**Files:**
- Modify: `AppleIntelligenceApp/AppleIntelligenceAppApp.swift`
- Delete: `AppleIntelligenceApp/ContentView.swift`

- [ ] **Step 1: Update AppleIntelligenceAppApp.swift to use EventExtractionView**

Replace the body of `AppleIntelligenceAppApp`:

```swift
import SwiftUI

@main
struct AppleIntelligenceAppApp: App {
    var body: some Scene {
        WindowGroup {
            EventExtractionView()
        }
    }
}
```

- [ ] **Step 2: Delete ContentView.swift**

Run:
```bash
rm AppleIntelligenceApp/ContentView.swift
```

Note: Also remove `ContentView.swift` from the Xcode project file if it's still referenced.

- [ ] **Step 3: Build to verify everything wires up**

Run:
```bash
xcodebuild -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp build -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -5
```
Expected: `BUILD SUCCEEDED`

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: wire EventExtractionView as root view, remove ContentView"
```

---

### Task 6: Run Tests

**Files:**
- Verify: `AppleIntelligenceAppTests/AppleIntelligenceAppTests.swift`

- [ ] **Step 1: Verify existing tests still pass**

Run:
```bash
xcodebuild test -project AppleIntelligenceApp.xcodeproj -scheme AppleIntelligenceApp -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' 2>&1 | tail -10
```
Expected: `TEST SUCCEEDED` (the default test is a no-op, should pass)

- [ ] **Step 2: Fix any test failures**

If the existing test imports `ContentView` or references removed code, update the test file to remove those references.

- [ ] **Step 3: Commit if any test fixes were needed**

```bash
git add AppleIntelligenceAppTests/
git commit -m "fix: update tests after ContentView removal"
```
