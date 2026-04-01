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
