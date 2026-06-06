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
            StatusPill(title: "Äußere Sicht", symbol: "tray", tint: NullTheme.oxblood)
            Text("Hier landen Aufgaben, die von außen an dich herangetragen wurden. Du beobachtest, wie stark sie vom 0%-Ideal abweichen.")
                .font(.system(.title3, design: .serif).weight(.bold))
                .foregroundStyle(NullTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }

    private func taskCard(_ task: NullTask) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline.weight(.black))
                    .fixedSize(horizontal: false, vertical: true)
                Text("Äußere Abweichung \(task.ripeness) %. \(task.ripenessAside)")
                    .font(.subheadline)
                    .foregroundStyle(NullTheme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)
            }

            TaskStatusBadge(
                title: task.status.title,
                symbol: task.status.symbol,
                tint: task.hasGoldenPatina ? NullTheme.gold : NullTheme.navy
            )

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
                    Label(task.canAdvance ? "Druck steigt" : "Zurückstufen", systemImage: task.canAdvance ? "arrow.right" : "arrow.uturn.backward")
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
                .font(.headline.weight(.bold))
                .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text("Status")
                    .font(.caption2.weight(.black))
                    .textCase(.uppercase)
                    .foregroundStyle(tint.opacity(0.72))
                Text(title)
                    .font(.caption.weight(.black))
                    .lineLimit(3)
                    .minimumScaleFactor(0.86)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
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

            Text("Je voller der Balken, desto weiter weg von 0 %.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(NullTheme.mutedInk)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Äußere Abweichung \(value) Prozent")
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
                    TextField("Zum Beispiel: Bericht abgeben", text: $title)
                }

                Section {
                    Text("Steuerunterlagen abgeben")
                    Text("Team-Feedback beantworten")
                    Text("Keller für Besuch aufräumen")
                    Text("Rückruf erledigen")
                } header: {
                    Text("Geeignete Fremdaufgaben")
                }
            }
            .scrollContentBackground(.hidden)
            .background(NullTheme.parchment)
            .navigationTitle("Fremdaufgabe reifen lassen")
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
