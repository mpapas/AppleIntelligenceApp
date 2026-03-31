//
//  EventExtractionService.swift
//  AppleIntelligenceApp
//

import Foundation
import FoundationModels
import Observation

@Observable
class EventExtractionService {
    var extractedEvent: ExtractedEvent?
    var isExtracting = false
    var errorMessage: String?

    var isModelAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }

    @MainActor
    func extract(from text: String) async {
        guard SystemLanguageModel.default.isAvailable else {
            errorMessage = "Apple Intelligence is not available on this device."
            return
        }

        isExtracting = true
        errorMessage = nil
        extractedEvent = nil

        do {
            let session = LanguageModelSession(
                instructions: """
                    Extract event details from the user's natural language input. \
                    Parse out the attendees, date and time, location, and topic.
                    """
            )

            let response = try await session.respond(
                to: text,
                generating: ExtractedEvent.self
            )

            extractedEvent = response.content
        } catch {
            errorMessage = "Failed to extract event: \(error.localizedDescription)"
        }

        isExtracting = false
    }
}
