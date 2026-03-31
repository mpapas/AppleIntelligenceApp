//
//  EventExtractionView.swift
//  AppleIntelligenceApp
//

import SwiftUI

struct EventExtractionView: View {
    @State private var service = EventExtractionService()
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextEditor(text: $inputText)
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary.opacity(0.3))
                    )
                    .overlay(alignment: .topLeading) {
                        if inputText.isEmpty {
                            Text("Describe an event...")
                                .foregroundStyle(.tertiary)
                                .padding(8)
                                .allowsHitTesting(false)
                        }
                    }

                Button {
                    Task {
                        await service.extract(from: inputText)
                    }
                } label: {
                    Label("Extract Event", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.isEmpty || service.isExtracting)

                if service.isExtracting {
                    ProgressView("Extracting...")
                }

                if let event = service.extractedEvent {
                    EventCardView(event: event)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let error = service.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                if !service.isModelAvailable {
                    ContentUnavailableView(
                        "Apple Intelligence Unavailable",
                        systemImage: "brain",
                        description: Text("Enable Apple Intelligence in Settings to use this feature.")
                    )
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Event Extractor")
            .animation(.default, value: service.extractedEvent != nil)
        }
    }
}

#Preview {
    EventExtractionView()
}
