import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: NullStore
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    VStack(spacing: 16) {
                        hero

                        HStack(spacing: 12) {
                            NullMetric(value: "\(store.todayNullQuote) %", label: "Nullquote heute", symbol: "percent", tint: NullTheme.oxblood)
                            NullMetric(value: "\(store.totalPotentialityDays)", label: "Tage Potenzial", symbol: "sparkles", tint: NullTheme.navy)
                        }

                        NullCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Null-Spruch")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(NullTheme.oxblood)
                                Text(store.dailyMantra)
                                    .font(.system(.title3, design: .serif).weight(.bold))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        NullButton(title: "Nichts tun", systemImage: "hand.raised.fill") {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                                store.registerDoNothing()
                                showSuccess = true
                            }
                        }

                        if showSuccess {
                            NullCard(fill: NullTheme.ink) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(NullTheme.oxblood)
                                        .font(.title2)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Erfolgreich.")
                                            .font(.headline.weight(.black))
                                        Text("Du hast verhindert, dass aus Absicht Belastung wird.")
                                            .font(.subheadline)
                                            .foregroundStyle(NullTheme.paper.opacity(0.78))
                                    }
                                }
                                .foregroundStyle(NullTheme.paper)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        VStack(spacing: 12) {
                            dashboardRow(
                                title: "Nicht begonnen",
                                value: store.habits.first?.title ?? "Neue Gewohnheit",
                                detail: "\(store.reassuredHabitsTodayCount) von \(store.habits.count) Nichtbeginnen heute bestätigt",
                                symbol: "square.dashed"
                            )

                            dashboardRow(
                                title: "Strategisch reifend",
                                value: store.tasks.first?.title ?? "Neue Aufgabe",
                                detail: "Reifegrad \(store.tasks.first?.ripeness ?? 0) %",
                                symbol: "archivebox"
                            )

                            dashboardRow(
                                title: "Nichtstun registriert",
                                value: "\(store.doNothingCount) mal",
                                detail: "Jede Wiederholung erhöht die Stabilität.",
                                symbol: "chart.line.flattrend.xyaxis"
                            )
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Das Null-Prinzip")
            .toolbarBackground(NullTheme.parchment, for: .navigationBar)
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("BookCover")
                .resizable()
                .scaledToFill()
                .frame(height: 248)
                .frame(maxWidth: .infinity)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.06), .black.opacity(0.72)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Heute: \(store.todayNullQuote) %")
                    .font(.system(size: 40, weight: .black, design: .default))
                    .foregroundStyle(NullTheme.paper)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("Nullquote aus dem Tracker. Umsetzung bleibt 0 %.")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(NullTheme.paper.opacity(0.9))
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(NullTheme.rule, lineWidth: 1)
        )
    }

    private func dashboardRow(title: String, value: String, detail: String, symbol: String) -> some View {
        NullCard {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: symbol)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(NullTheme.oxblood)
                    .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.caption.weight(.black))
                        .foregroundStyle(NullTheme.oxblood)
                    Text(value)
                        .font(.headline.weight(.black))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(NullTheme.mutedInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
