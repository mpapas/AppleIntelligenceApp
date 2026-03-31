//
//  ExtractedEvent.swift
//  AppleIntelligenceApp
//

import FoundationModels

@Generable
struct ExtractedEvent {
    @Guide(description: "The person or people attending the event")
    var attendees: String

    @Guide(description: "The date and time of the event")
    var dateTime: String

    @Guide(description: "The location where the event takes place")
    var location: String

    @Guide(description: "The topic or purpose of the event")
    var topic: String
}
