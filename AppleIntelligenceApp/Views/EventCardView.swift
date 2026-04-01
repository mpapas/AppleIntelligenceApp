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
