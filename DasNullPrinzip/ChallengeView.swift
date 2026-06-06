import SwiftUI

struct ChallengeView: View {
    @EnvironmentObject private var store: NullStore

    var body: some View {
        NavigationStack {
            NullScreen {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        NullCard(fill: NullTheme.navy) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("30-Tage-0%-Challenge")
                                    .font(.system(.title2, design: .serif).weight(.black))
                                Text("Jeden Tag verhinderst du, dass aus Absicht Belastung wird.")
                                    .font(.subheadline)
                                    .foregroundStyle(NullTheme.paper.opacity(0.8))
                                    .fixedSize(horizontal: false, vertical: true)
                                ProgressView(value: Double(store.challengeProgress.count), total: 30)
                                    .tint(NullTheme.oxblood)
                                Text("\(store.challengeProgress.count) von 30 Tagen erfolgreich nicht eskaliert")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(NullTheme.paper.opacity(0.75))
                            }
                            .foregroundStyle(NullTheme.paper)
                        }

                        ForEach(ChallengeDay.all) { day in
                            dayCard(day)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("30 Tage")
        }
    }

    private func dayCard(_ day: ChallengeDay) -> some View {
        let isDone = store.challengeProgress.contains(day.id)

        return NullCard(fill: isDone ? NullTheme.paper.opacity(0.78) : NullTheme.paper) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    store.toggleChallengeDay(day.id)
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
