import SwiftUI

struct ChallengeView: View {
    @EnvironmentObject private var store: NullStore
    @State private var isShowingCompletion = false

    var body: some View {
        NavigationStack {
            NullScreen {
                VStack(spacing: 0) {
                    compactProgress

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            NullCard(fill: NullTheme.navy) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("30-Tage-Nullstand-Challenge")
                                        .font(.system(.title2, design: .serif).weight(.black))
                                    Text("Jeden Tag verhinderst du, dass aus Absicht Belastung wird.")
                                        .font(.subheadline)
                                        .foregroundStyle(NullTheme.paper.opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                    ProgressView(value: Double(store.challengeProgress.count), total: Double(ChallengeDay.dayCount))
                                        .tint(NullTheme.oxblood)
                                    Text(progressSentence)
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(NullTheme.paper.opacity(0.75))
                                }
                                .foregroundStyle(NullTheme.paper)
                            }

                            ForEach(store.challengeDays) { day in
                                dayCard(day)
                            }
                        }
                        .padding(16)
                        .nullTabBarClearance()
                    }
                }
            }
            .navigationTitle("30 Tage")
            .sheet(isPresented: $isShowingCompletion) {
                ChallengeCompletionSheet {
                    store.restartChallenge()
                }
            }
        }
    }

    private var progressSentence: String {
        "\(store.challengeProgress.count) von \(ChallengeDay.dayCount) Tagen erfolgreich nicht eskaliert"
    }

    private var compactProgress: some View {
        VStack(alignment: .leading, spacing: 7) {
            ProgressView(value: Double(store.challengeProgress.count), total: Double(ChallengeDay.dayCount))
                .tint(NullTheme.oxblood)
            Text(progressSentence)
                .font(.caption.weight(.bold))
                .foregroundStyle(NullTheme.mutedInk)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(NullTheme.parchment)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(NullTheme.rule)
                .frame(height: 1)
        }
    }

    private func dayCard(_ day: ChallengeDay) -> some View {
        let isDone = store.challengeProgress.contains(day.id)

        return NullCard(fill: isDone ? NullTheme.paper.opacity(0.78) : NullTheme.paper) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    store.toggleChallengeDay(day.id)
                    if store.isChallengeComplete {
                        isShowingCompletion = true
                    }
                } label: {
                    ChallengeCheckbox(isDone: isDone)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isDone ? "Tag als offen markieren" : "Tag als nicht begonnen markieren")

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        StatusPill(title: "Tag \(day.id)", tint: isDone ? NullTheme.oxblood : NullTheme.navy)
                        Text(day.title)
                            .font(.headline.weight(.black))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(day.line)
                        .font(.subheadline)
                        .foregroundStyle(NullTheme.mutedInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private struct ChallengeCompletionSheet: View {
    @Environment(\.dismiss) private var dismiss
    let restart: () -> Void

    var body: some View {
        NavigationStack {
            NullScreen {
                VStack(alignment: .leading, spacing: 18) {
                    Spacer(minLength: 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("30 Tage im Nullstand.")
                            .font(.system(.largeTitle, design: .serif).weight(.black))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Du hast verhindert, dass aus Absicht Belastung wird. Das Null-Prinzip wirkt.")
                            .font(.headline)
                            .foregroundStyle(NullTheme.mutedInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    NullCard(fill: NullTheme.ink) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Zertifikat der Nichteskalation")
                                .font(.caption.weight(.black))
                                .foregroundStyle(NullTheme.oxblood)
                            Text("Diese Challenge ist nun stabil abgeschlossen und bereit, in leicht anderer Reihenfolge erneut nicht bewältigt zu werden.")
                                .font(.system(.title3, design: .serif).weight(.bold))
                                .foregroundStyle(NullTheme.paper)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    NullButton(title: "Challenge neu reifen lassen", systemImage: "arrow.clockwise", fill: NullTheme.oxblood) {
                        restart()
                        dismiss()
                    }

                    Spacer(minLength: 20)
                }
                .padding(18)
            }
            .navigationTitle("Abgeschlossen")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

private struct ChallengeCheckbox: View {
    let isDone: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(isDone ? NullTheme.oxblood.opacity(0.12) : Color.clear)
                .overlay {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(isDone ? NullTheme.oxblood : NullTheme.mutedInk, lineWidth: 2)
                }

            CheckmarkShape()
                .trim(from: 0, to: isDone ? 1 : 0)
                .stroke(
                    NullTheme.oxblood,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                .padding(8)
        }
        .frame(width: 34, height: 34)
        .contentShape(Rectangle())
        .animation(.spring(response: 0.24, dampingFraction: 0.82), value: isDone)
    }
}

private struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX * 0.82, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}
