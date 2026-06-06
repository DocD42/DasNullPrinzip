import SwiftUI

struct TrackerView: View {
    @EnvironmentObject private var store: NullStore
    @State private var isAddingHabit = false

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        trackerIntro
                        trackerProgress

                        ForEach(store.habits) { habit in
                            habitCard(habit)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Gewohnheit hinzufügen")
                }
            }
            .sheet(isPresented: $isAddingHabit) {
                AddHabitSheet()
                    .environmentObject(store)
            }
        }
    }

    private var trackerIntro: some View {
        NullCard(fill: NullTheme.navy) {
            VStack(alignment: .leading, spacing: 8) {
                Text("0%-Tracker")
                    .font(.system(.title2, design: .serif).weight(.black))
                Text("Hier liegen Vorhaben, die heute unangetastet bleiben. Reifen ist für Aufgaben, deren Status wandert.")
                    .font(.subheadline)
                    .foregroundStyle(NullTheme.paper.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(NullTheme.paper)
        }
    }

    private var trackerProgress: some View {
        NullCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nullquote heute")
                            .font(.caption.weight(.black))
                            .foregroundStyle(NullTheme.oxblood)
                        Text("\(store.todayNullQuote) %")
                            .font(.system(.largeTitle, design: .serif).weight(.black))
                            .lineLimit(1)
                    }
                    Spacer(minLength: 8)
                    StatusPill(title: "\(store.reassuredHabitsTodayCount)/\(store.habits.count)", symbol: "checkmark")
                }

                TrackerMeter(value: store.todayNullQuote)

                Text("Jede bestätigte Box erhöht die Tagesquote. Der Inhalt selbst bleibt natürlich bei 0 % Umsetzung.")
                    .font(.subheadline)
                    .foregroundStyle(NullTheme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func habitCard(_ habit: NullHabit) -> some View {
        NullCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(habit.title)
                            .font(.headline.weight(.black))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(habit.milestone)
                            .font(.subheadline)
                            .foregroundStyle(NullTheme.mutedInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 8)
                    StatusPill(title: "\(habit.daysUnstarted) Tage", symbol: "moon")
                }

                if !habit.notes.isEmpty {
                    Text(habit.notes)
                        .font(.caption)
                        .foregroundStyle(NullTheme.mutedInk)
                }

                Text(habit.trackerLine)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NullTheme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            store.reassure(habit: habit)
                        }
                    } label: {
                        Label(habit.isReassuredToday ? "Heute gesichert" : "Heute nicht begonnen", systemImage: habit.trackerStatusSymbol)
                            .font(.subheadline.weight(.bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(habit.isReassuredToday ? NullTheme.navy : NullTheme.paper)
                    .background(habit.isReassuredToday ? NullTheme.navy.opacity(0.10) : NullTheme.oxblood)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel(habit.trackerStatusTitle)

                    Button(role: .destructive) {
                        store.deleteHabit(habit)
                    } label: {
                        Image(systemName: "trash")
                            .font(.headline.weight(.bold))
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(NullTheme.oxblood)
                    .background(NullTheme.oxblood.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel("Gewohnheit löschen")
                }
            }
        }
    }
}

private struct TrackerMeter: View {
    let value: Int

    var body: some View {
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
        .accessibilityLabel("Nullquote \(value) Prozent")
    }
}

struct AddHabitSheet: View {
    @EnvironmentObject private var store: NullStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Zum Beispiel: Meditation", text: $title)
                }

                Section {
                    Text("Joggen")
                    Text("Spanisch lernen")
                    Text("Buch schreiben")
                    Text("Steuerunterlagen sortieren")
                } header: {
                    Text("Geeignete Nichtbeginne")
                }
            }
            .scrollContentBackground(.hidden)
            .background(NullTheme.parchment)
            .navigationTitle("Nicht beginnen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Anlegen") {
                        store.addHabit(title: title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
