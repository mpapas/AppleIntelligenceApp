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
