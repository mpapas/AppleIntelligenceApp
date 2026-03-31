//
//  ExtractedEventTests.swift
//  AppleIntelligenceAppTests
//

import Testing
@testable import AppleIntelligenceApp

struct ExtractedEventTests {

    @Test func eventHasExpectedProperties() async throws {
        let event = ExtractedEvent(
            attendees: "Sarah",
            dateTime: "Next Friday at noon",
            location: "Café Roma",
            topic: "Rebrand discussion"
        )

        #expect(event.attendees == "Sarah")
        #expect(event.dateTime == "Next Friday at noon")
        #expect(event.location == "Café Roma")
        #expect(event.topic == "Rebrand discussion")
    }
}
