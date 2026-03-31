//
//  EventExtractionServiceTests.swift
//  AppleIntelligenceAppTests
//

import Testing
@testable import AppleIntelligenceApp

struct EventExtractionServiceTests {

    @Test func serviceInitializesWithNilState() async throws {
        let service = EventExtractionService()

        #expect(service.extractedEvent == nil)
        #expect(service.isExtracting == false)
        #expect(service.errorMessage == nil)
    }

    @Test func serviceReportsModelAvailability() async throws {
        let service = EventExtractionService()

        // isModelAvailable should return a Bool without crashing
        let _ = service.isModelAvailable
    }
}
