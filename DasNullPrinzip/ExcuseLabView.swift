import SwiftUI

struct ExcuseLabView: View {
    @State private var topic = "Ich habe den Bericht nicht geschrieben."
    @State private var mode: ExcuseMode = .corporate
    @State private var result = ExcuseFactory.generate(for: "Ich habe den Bericht nicht geschrieben.", mode: .corporate)
    @State private var isSharing = false
    @FocusState private var isTopicFocused: Bool

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    VStack(spacing: 14) {
                        NullCard(fill: NullTheme.ink) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ausreden-Generator")
                                    .font(.system(.title2, design: .serif).weight(.black))
                                Text("Verwandle Nichtumsetzung in anschlussfähige Begründung.")
                                    .font(.subheadline)
                                    .foregroundStyle(NullTheme.paper.opacity(0.78))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundStyle(NullTheme.paper)
                        }

                        NullCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Nicht getan")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(NullTheme.oxblood)

                                TextEditor(text: $topic)
                                    .focused($isTopicFocused)
                                    .frame(minHeight: 104)
                                    .padding(8)
                                    .background(Color.white.opacity(0.36))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(NullTheme.rule, lineWidth: 1)
                                    )
                                    .scrollContentBackground(.hidden)

                                Picker("Modus", selection: $mode) {
                                    ForEach(ExcuseMode.allCases) { mode in
                                        Label(mode.title, systemImage: mode.symbol)
                                            .tag(mode)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(NullTheme.oxblood)

                                NullButton(title: "Ausrede erzeugen", systemImage: "wand.and.stars", fill: NullTheme.oxblood) {
                                    isTopicFocused = false
                                    result = ExcuseFactory.generate(for: topic, mode: mode)
                                }
                            }
                        }

                        NullCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    StatusPill(title: mode.title, symbol: mode.symbol)
                                    Spacer()
                                    Button {
                                        isSharing = true
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .frame(width: 36, height: 36)
                                    }
                                    .buttonStyle(.bordered)
                                    .accessibilityLabel("Ausrede teilen")
                                }

                                Text(result)
                                    .font(.system(.title3, design: .serif).weight(.bold))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(16)
                    .nullTabBarClearance()
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Ausreden")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fertig") {
                        isTopicFocused = false
                    }
                    .font(.headline.weight(.semibold))
                    .tint(NullTheme.oxblood)
                }
            }
            .sheet(isPresented: $isSharing) {
                ShareSheet(items: [result])
            }
        }
    }
}
