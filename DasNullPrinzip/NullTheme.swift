import SwiftUI

enum NullTheme {
    static let parchment = Color(red: 0.91, green: 0.86, blue: 0.78)
    static let paper = Color(red: 0.98, green: 0.95, blue: 0.88)
    static let ink = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let mutedInk = Color(red: 0.28, green: 0.26, blue: 0.23)
    static let oxblood = Color(red: 0.55, green: 0.10, blue: 0.08)
    static let navy = Color(red: 0.05, green: 0.13, blue: 0.18)
    static let sofaGray = Color(red: 0.47, green: 0.46, blue: 0.42)
    static let rule = Color.black.opacity(0.16)
}

struct NullScreen<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            NullTheme.parchment
                .ignoresSafeArea()
            content
        }
        .foregroundStyle(NullTheme.ink)
    }
}

struct NullCard<Content: View>: View {
    private let fill: Color
    private let content: Content

    init(fill: Color = NullTheme.paper, @ViewBuilder content: () -> Content) {
        self.fill = fill
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(NullTheme.rule, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 5)
    }
}

struct NullMetric: View {
    let value: String
    let label: String
    let symbol: String
    var tint: Color = NullTheme.oxblood

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .font(.title3.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
            Text(value)
                .font(.system(.title2, design: .serif).weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(NullTheme.mutedInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 116, alignment: .leading)
        .background(NullTheme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(NullTheme.rule, lineWidth: 1)
        )
    }
}

struct NullButton: View {
    let title: String
    let systemImage: String
    var fill: Color = NullTheme.ink
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(fill)
                .foregroundStyle(NullTheme.paper)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct StatusPill: View {
    let title: String
    var symbol: String?
    var tint: Color = NullTheme.oxblood

    var body: some View {
        HStack(spacing: 6) {
            if let symbol {
                Image(systemName: symbol)
            }
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .font(.caption.weight(.bold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundStyle(tint)
        .background(tint.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
