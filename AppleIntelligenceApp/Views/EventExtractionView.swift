import SwiftUI
import FoundationModels

struct EventExtractionView: View {
    @State private var service = EventExtractionService()
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Event Extractor")
        }
    }

    @ViewBuilder
    private var content: some View {
        if service.isAvailable {
            extractionView
        } else {
            unavailableView
        }
    }

    private var extractionView: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Describe your event...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)

                Button {
                    Task { await service.extractEvent(from: inputText) }
                } label: {
                    Label("Extract Event", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || service.isExtracting)

                if service.isExtracting {
                    ProgressView("Extracting event details...")
                }

                if let event = service.extractedEvent {
                    EventCardView(event: event)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let error = service.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                }
            }
            .padding()
            .animation(.default, value: service.extractedEvent != nil)
        }
    }

    @ViewBuilder
    private var unavailableView: some View {
        switch SystemLanguageModel.default.availability {
        case .available:
            EmptyView()
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                ContentUnavailableView(
                    "Device Not Supported",
                    systemImage: "iphone.slash",
                    description: Text("This device doesn't support on-device AI models.")
                )
            case .appleIntelligenceNotEnabled:
                ContentUnavailableView(
                    "Apple Intelligence Disabled",
                    systemImage: "brain",
                    description: Text("Enable Apple Intelligence in Settings > Apple Intelligence & Siri.")
                )
            case .modelNotReady:
                ContentUnavailableView(
                    "Model Preparing",
                    systemImage: "arrow.down.circle",
                    description: Text("The AI model is downloading. Please try again shortly.")
                )
            @unknown default:
                ContentUnavailableView(
                    "Unavailable",
                    systemImage: "exclamationmark.triangle",
                    description: Text("On-device AI is not available.")
                )
            }
        }
    }
}

#Preview {
    EventExtractionView()
}
