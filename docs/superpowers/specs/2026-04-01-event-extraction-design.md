# Smart Event Extraction — Design Spec

**Issue:** #1 — Add smart event extraction using on-device Apple Intelligence
**Date:** 2026-04-01
**Status:** Approved

## Overview

Parse natural language event descriptions (e.g., "Lunch with Sarah next Friday at noon at Cafe Roma to discuss the rebrand") into structured event cards using Apple's on-device Foundation Models framework with `@Generable` structured output.

## Approach

Single-view architecture with `@Generable` structured output. No tool calling, no protocol abstraction — focused on clearly demonstrating the Foundation Models framework in a sample app.

## Model Layer

### ExtractedEvent

A `@Generable` struct the on-device model fills via structured generation.

```swift
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
```

All fields are strings (or string arrays). The model extracts entities as-is — no date parsing or reasoning. This plays to the on-device model's strength (entity extraction) and avoids its weakness (logical reasoning, math).

## Service Layer

### EventExtractionService

An `@Observable` class responsible for:

1. Checking `SystemLanguageModel.default.availability` and exposing availability state
2. Creating a `LanguageModelSession` with focused extraction instructions
3. Calling `session.respond(to:, generating: ExtractedEvent.self)` to produce structured output
4. Tracking `isExtracting` state for UI binding

Key behaviors:
- Session created lazily on first extraction (not at init) to avoid unnecessary resource allocation
- Instructions tell the model it is an event parser that extracts structured fields from natural language
- Exposes the detailed `SystemLanguageModel.Availability` for the view to show specific unavailability reasons

## View Layer

### EventExtractionView (main screen)

- `TextField` for natural language input
- "Extract" button with SF Symbol, disabled while extracting or when input is empty
- Shows `EventCardView` when extraction succeeds
- Shows `ContentUnavailableView` with specific reason when model is unavailable:
  - Device not eligible
  - Apple Intelligence not enabled
  - Model not ready (downloading/updating)
- Shows error message on extraction failure

### EventCardView (result display)

A card displaying the extracted event fields with SF Symbols:
- `person.2` — Attendees (comma-separated or listed)
- `calendar` — Date & Time
- `mappin.and.ellipse` — Location
- `text.quote` — Topic

Styled as a rounded card with grouped rows.

## File Structure

```
AppleIntelligenceApp/
├── AppleIntelligenceAppApp.swift      (modify: pass service to view)
├── Models/
│   └── ExtractedEvent.swift           (new)
├── Services/
│   └── EventExtractionService.swift   (new)
└── Views/
    ├── EventExtractionView.swift      (new)
    └── EventCardView.swift            (new)
```

ContentView.swift will be removed — replaced by EventExtractionView as the root view.

## Availability Handling

```swift
switch SystemLanguageModel.default.availability {
case .available:
    // Show extraction UI
case .unavailable(.deviceNotEligible):
    // "This device doesn't support on-device AI."
case .unavailable(.appleIntelligenceNotEnabled):
    // "Enable Apple Intelligence in Settings > Apple Intelligence & Siri."
case .unavailable(.modelNotReady):
    // "The AI model is preparing. Please try again shortly."
}
```

## Constraints and Decisions

- **On-device only** — no server calls, no network requests
- **String-based date/time** — model extracts the date/time phrase as-is, no `Date` conversion
- **No protocol abstraction** — sample app, not production; keeps code focused on demonstrating the framework
- **`@Generable` over tool calling** — extraction is a structured output task, not an action task
- **4,096 token context window** — event descriptions are short, well within limits
- **iOS 26+ / macOS 26+** — required for FoundationModels framework

## Acceptance Criteria Mapping

| Criteria | Implementation |
|----------|---------------|
| Text input field for natural language entry | `TextField` in `EventExtractionView` |
| Parsed event card with labeled fields | `EventCardView` with SF Symbols |
| Graceful handling when model isn't available | `ContentUnavailableView` with specific reason |
| Works entirely on-device via FoundationModels | `SystemLanguageModel.default`, no network calls |
