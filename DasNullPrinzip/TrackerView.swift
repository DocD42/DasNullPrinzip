import SwiftUI

struct TrackerView: View {
    @EnvironmentObject private var store: NullStore
    @State private var isAddingHabit = false

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        NullCard(fill: NullTheme.navy) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("0%-Tracker")
                                    .font(.system(.title2, design: .serif).weight(.black))
                                Text("Tracke nicht, ob du etwas getan hast, sondern wie stabil du es nicht begonnen hast.")
                                    .font(.subheadline)
                                    .foregroundStyle(NullTheme.paper.opacity(0.78))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundStyle(NullTheme.paper)
                        }

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

                HStack(spacing: 10) {
                    Button {
                        store.reassure(habit: habit)
                    } label: {
                        Label("Weiter nicht begonnen", systemImage: "hand.raised")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(NullTheme.ink)

                    Button(role: .destructive) {
                        store.deleteHabit(habit)
                    } label: {
                        Image(systemName: "trash")
                            .frame(width: 38, height: 34)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Gewohnheit löschen")
                }
            }
        }
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
