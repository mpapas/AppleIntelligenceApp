//
//  EventCardView.swift
//  AppleIntelligenceApp
//

import SwiftUI

struct EventCardView: View {
    let event: ExtractedEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(event.attendees, systemImage: "person.fill")
            Label(event.dateTime, systemImage: "calendar")
            Label(event.location, systemImage: "mappin.and.ellipse")
            Label(event.topic, systemImage: "text.bubble.fill")
        }
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    EventCardView(event: ExtractedEvent(
        attendees: "Sarah",
        dateTime: "Friday at 12:00 PM",
        location: "Café Roma",
        topic: "Rebrand discussion"
    ))
    .padding()
}
