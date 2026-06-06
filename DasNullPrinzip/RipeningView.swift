import SwiftUI

struct RipeningView: View {
    @EnvironmentObject private var store: NullStore
    @State private var isAddingTask = false

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ripeningIntro

                        ForEach(store.tasks) { task in
                            taskCard(task)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Reifen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Aufgabe hinzufügen")
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskSheet()
                    .environmentObject(store)
            }
        }
    }

    private var ripeningIntro: some View {
        VStack(alignment: .leading, spacing: 8) {
            StatusPill(title: "Prinzip", symbol: "hourglass", tint: NullTheme.oxblood)
            Text("Aufgaben werden nicht erledigt. Sie reifen, bis die Realität sie übernimmt.")
                .font(.system(.title3, design: .serif).weight(.bold))
                .foregroundStyle(NullTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }

    private func taskCard(_ task: NullTask) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.headline.weight(.black))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Reifegrad \(task.ripeness) %. \(task.ripenessAside)")
                        .font(.subheadline)
                        .foregroundStyle(NullTheme.mutedInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
                Spacer(minLength: 8)
                TaskStatusBadge(
                    title: task.status.title,
                    symbol: task.status.symbol,
                    tint: task.hasGoldenPatina ? NullTheme.gold : NullTheme.navy
                )
            }

            HStack(spacing: 8) {
                DurationPill(
                    compactLabel: task.statusDurationCompactLabel,
                    fullLabel: task.statusDurationLabel,
                    isHighlighted: task.hasGoldenPatina
                )

                if task.hasGoldenPatina {
                    StatusPill(title: "Langzeitreife", symbol: "seal", tint: NullTheme.gold)
                }
            }

            RipenessBar(value: task.ripeness)

            HStack(spacing: 10) {
                Button {
                    if task.canAdvance {
                        store.advance(task: task)
                    } else {
                        store.regress(task: task)
                    }
                } label: {
                    Label(task.canAdvance ? "Weiter reifen lassen" : "Zurückstufen", systemImage: task.canAdvance ? "arrow.right" : "arrow.uturn.backward")
                        .font(.subheadline.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                }
                .buttonStyle(.plain)
                .foregroundStyle(NullTheme.paper)
                .background(task.canAdvance ? NullTheme.oxblood : NullTheme.navy)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                if task.canAdvance, task.canRegress {
                    Button {
                        store.regress(task: task)
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.headline.weight(.bold))
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(NullTheme.navy)
                    .background(NullTheme.navy.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel("Reife zurückstufen")
                }

                Button(role: .destructive) {
                    store.deleteTask(task)
                } label: {
                    Image(systemName: "trash")
                        .font(.headline.weight(.bold))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .foregroundStyle(NullTheme.oxblood)
                .background(NullTheme.oxblood.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accessibilityLabel("Aufgabe löschen")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NullTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(task.hasGoldenPatina ? NullTheme.gold : NullTheme.rule, lineWidth: task.hasGoldenPatina ? 2 : 1)
        )
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 5)
    }
}

private struct DurationPill: View {
    let compactLabel: String
    let fullLabel: String
    let isHighlighted: Bool

    var body: some View {
        Label("Seit \(compactLabel)", systemImage: "timer")
            .font(.caption.weight(.black))
            .lineLimit(1)
            .minimumScaleFactor(0.72)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(isHighlighted ? NullTheme.gold : NullTheme.mutedInk)
            .background((isHighlighted ? NullTheme.gold : NullTheme.navy).opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .accessibilityLabel("\(fullLabel) in diesem Zustand")
    }
}

private struct TaskStatusBadge: View {
    let title: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: symbol)
                .font(.caption.weight(.bold))
                .frame(width: 13)

            Text(title)
                .font(.caption.weight(.bold))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: 164, alignment: .leading)
        .foregroundStyle(tint)
        .background(tint.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .accessibilityLabel(title)
    }
}

private struct RipenessBar: View {
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(NullTheme.oxblood.opacity(0.12))
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(NullTheme.oxblood)
                        .frame(width: proxy.size.width * CGFloat(value) / 100)
                }
            }
            .frame(height: 10)

            Text("100 % wäre Erledigung. Diese App endet vorher.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(NullTheme.mutedInk)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Reifegrad \(value) Prozent")
    }
}

struct AddTaskSheet: View {
    @EnvironmentObject private var store: NullStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Zum Beispiel: Keller aufräumen", text: $title)
                }

                Section {
                    Text("Neu eingegangen")
                    Text("Liegt gut")
                    Text("Reift")
                    Text("Ohne Gesichtsverlust verschwunden")
                } header: {
                    Text("Statuslogik")
                }
            }
            .scrollContentBackground(.hidden)
            .background(NullTheme.parchment)
            .navigationTitle("Reifen lassen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Anlegen") {
                        store.addTask(title: title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
