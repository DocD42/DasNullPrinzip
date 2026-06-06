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
                    .accessibilityLabel("Idee hinzufügen")
                }
            }
            .sheet(isPresented: $isAddingHabit) {
                AddHabitSheet()
                    .environmentObject(store)
            }
        }
    }

    private var trackerIntro: some View {
        VStack(alignment: .leading, spacing: 8) {
            StatusPill(title: "Innere Sicht", symbol: "lightbulb", tint: NullTheme.gold)
            Text("0%-Tracker")
                .font(.system(.title2, design: .serif).weight(.black))
                .foregroundStyle(NullTheme.ink)
            Text("Selbst gewählte Ideen und Challenges bleiben hier möglichst unberührt.")
                .font(.subheadline)
                .foregroundStyle(NullTheme.mutedInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }

    private var trackerProgress: some View {
        NullCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Innere Abweichung")
                            .font(.caption.weight(.black))
                            .foregroundStyle(NullTheme.oxblood)
                        Text("\(store.trackerDeviationScore) %")
                            .font(.system(.largeTitle, design: .serif).weight(.black))
                            .lineLimit(1)
                    }
                    Spacer(minLength: 8)
                    StatusPill(title: "\(store.habits.count) Ideen", symbol: "lightbulb")
                }

                TrackerMeter(value: store.trackerDeviationScore)

                Text("0 % heißt: Idee bleibt Idee. Nachdenken, Vorbereiten, Einplanen und Anfangen ziehen dich Richtung 100 %.")
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
                        Text("Abweichung \(habit.deviation) %. \(habit.milestone)")
                            .font(.subheadline)
                            .foregroundStyle(NullTheme.mutedInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 8)
                    IdeaStatusBadge(
                        title: habit.currentStatus.title,
                        symbol: habit.currentStatus.symbol,
                        tint: habit.deviation == 0 ? NullTheme.navy : NullTheme.oxblood
                    )
                }

                if !habit.notes.isEmpty {
                    Text(habit.notes)
                        .font(.caption)
                        .foregroundStyle(NullTheme.mutedInk)
                }

                HStack(spacing: 8) {
                    StatusPill(title: "\(habit.daysUnstarted) Tage ungestartet", symbol: "moon", tint: NullTheme.navy)
                    if habit.deviation == 0 {
                        StatusPill(title: "Ideal", symbol: "checkmark", tint: NullTheme.gold)
                    }
                }

                TrackerMeter(value: habit.deviation)

                HStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            if habit.canAdvance {
                                store.advanceIdea(habit)
                            } else {
                                store.resetIdea(habit)
                            }
                        }
                    } label: {
                        Label(habit.canAdvance ? "Wird konkret" : "Zurück auf 0 %", systemImage: habit.canAdvance ? "arrow.right" : "arrow.uturn.backward")
                            .font(.subheadline.weight(.bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(NullTheme.paper)
                    .background(habit.canAdvance ? NullTheme.oxblood : NullTheme.navy)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel(habit.canAdvance ? "Idee wird konkreter" : "Idee auf null Prozent zurücksetzen")

                    if habit.canAdvance, habit.canRegress {
                        Button {
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                                store.regressIdea(habit)
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.headline.weight(.bold))
                                .frame(width: 40, height: 40)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(NullTheme.navy)
                        .background(NullTheme.navy.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .accessibilityLabel("Idee weiter von der Umsetzung entfernen")
                    }

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
                    .accessibilityLabel("Idee löschen")
                }
            }
        }
    }
}

private struct IdeaStatusBadge: View {
    let title: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: symbol)
                .font(.caption.weight(.bold))
                .frame(width: 14)

            Text(title)
                .font(.caption.weight(.bold))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(width: 136, alignment: .leading)
        .foregroundStyle(tint)
        .background(tint.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .accessibilityLabel(title)
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
        .accessibilityLabel("Abweichung \(value) Prozent")
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
                    TextField("Zum Beispiel: Podcast anfangen", text: $title)
                }

                Section {
                    Text("5-Uhr-Morgenroutine")
                    Text("Podcast beginnen")
                    Text("Romanprojekt starten")
                    Text("KI-Kurs durcharbeiten")
                } header: {
                    Text("Geeignete innere Vorhaben")
                }
            }
            .scrollContentBackground(.hidden)
            .background(NullTheme.parchment)
            .navigationTitle("Idee nicht beginnen")
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
