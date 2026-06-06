import SwiftUI

struct RipeningView: View {
    @EnvironmentObject private var store: NullStore
    @State private var isAddingTask = false

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        NullCard(fill: NullTheme.oxblood) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Strategisches Reifen")
                                    .font(.system(.title2, design: .serif).weight(.black))
                                Text("Manche Aufgaben lösen sich durch die professionelle Vermeidung vorschneller Intervention.")
                                    .font(.subheadline)
                                    .foregroundStyle(NullTheme.paper.opacity(0.82))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundStyle(NullTheme.paper)
                        }

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

    private func taskCard(_ task: NullTask) -> some View {
        NullCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.title)
                            .font(.headline.weight(.black))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Reifegrad \(task.ripeness) %. Hat jemand noch einmal danach gefragt?")
                            .font(.subheadline)
                            .foregroundStyle(NullTheme.mutedInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 8)
                    StatusPill(title: task.status.title, symbol: task.status.symbol, tint: NullTheme.navy)
                }

                ProgressView(value: Double(task.ripeness), total: 100)
                    .tint(NullTheme.oxblood)

                HStack(spacing: 10) {
                    Button {
                        store.advance(task: task)
                    } label: {
                        Label("Weiter reifen lassen", systemImage: "arrow.right")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(NullTheme.ink)
                    .disabled(task.status == .disappearedWithDignity)

                    Button(role: .destructive) {
                        store.deleteTask(task)
                    } label: {
                        Image(systemName: "trash")
                            .frame(width: 38, height: 34)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Aufgabe löschen")
                }
            }
        }
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
