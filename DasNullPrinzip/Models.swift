import Foundation

struct NullHabit: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var lastReassuredAt: Date?
    var notes: String

    init(id: UUID = UUID(), title: String, createdAt: Date = Date(), lastReassuredAt: Date? = nil, notes: String = "") {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.lastReassuredAt = lastReassuredAt
        self.notes = notes
    }

    var daysUnstarted: Int {
        Calendar.current.dateComponents([.day], from: createdAt.dnpStartOfDay, to: Date().dnpStartOfDay).day ?? 0
    }

    var milestone: String {
        switch daysUnstarted {
        case 100...:
            "Du hast bewiesen, dass kurzfristige Motivation an dir abperlt."
        case 30...:
            "Diese Gewohnheit ist stabil nicht etabliert."
        case 7...:
            "Weiterhin im Zustand reiner Potenzialität."
        default:
            "Noch frisch. Bitte nicht durch Aktion gefährden."
        }
    }
}

enum NullTaskStatus: String, CaseIterable, Codable, Identifiable {
    case new
    case resting
    case ripening
    case almostSolved
    case delegatedByReality
    case historicallyInteresting
    case disappearedWithDignity

    var id: String { rawValue }

    var title: String {
        switch self {
        case .new: "Neu eingegangen"
        case .resting: "Liegt gut"
        case .ripening: "Reift"
        case .almostSolved: "Hat sich fast erledigt"
        case .delegatedByReality: "Von anderen übernommen"
        case .historicallyInteresting: "Historisch interessant"
        case .disappearedWithDignity: "Ohne Gesichtsverlust verschwunden"
        }
    }

    var symbol: String {
        switch self {
        case .new: "tray"
        case .resting: "archivebox"
        case .ripening: "hourglass"
        case .almostSolved: "sparkles"
        case .delegatedByReality: "person.2"
        case .historicallyInteresting: "clock.badge.questionmark"
        case .disappearedWithDignity: "checkmark.seal"
        }
    }

    var next: NullTaskStatus {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self), index < all.index(before: all.endIndex) else {
            return self
        }
        return all[all.index(after: index)]
    }
}

struct NullTask: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var status: NullTaskStatus

    init(id: UUID = UUID(), title: String, createdAt: Date = Date(), status: NullTaskStatus = .new) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.status = status
    }

    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: createdAt.dnpStartOfDay, to: Date().dnpStartOfDay).day ?? 0
    }

    var ripeness: Int {
        min(99, max(8, ageInDays * 7 + NullTaskStatus.allCases.firstIndex(of: status)! * 11))
    }
}

enum ExcuseMode: String, CaseIterable, Identifiable, Codable {
    case corporate
    case mindful
    case financiallyPrudent
    case stoic
    case therapeutic
    case boardSafe
    case relationshipSafe
    case parentEvening

    var id: String { rawValue }

    var title: String {
        switch self {
        case .corporate: "Corporate"
        case .mindful: "Achtsam"
        case .financiallyPrudent: "Finanziell klug"
        case .stoic: "Stoisch"
        case .therapeutic: "Therapeutisch"
        case .boardSafe: "Vorstandssicher"
        case .relationshipSafe: "Paargeeignet"
        case .parentEvening: "Elternabend"
        }
    }

    var symbol: String {
        switch self {
        case .corporate: "briefcase"
        case .mindful: "leaf"
        case .financiallyPrudent: "chart.line.downtrend.xyaxis"
        case .stoic: "building.columns"
        case .therapeutic: "bubble.left.and.text.bubble.right"
        case .boardSafe: "person.crop.rectangle.stack"
        case .relationshipSafe: "heart"
        case .parentEvening: "person.3"
        }
    }
}

struct ChallengeDay: Identifiable {
    let id: Int
    let title: String
    let line: String

    static let dayCount = 30

    static func days(for cycle: Int) -> [ChallengeDay] {
        guard cycle > 0 else { return base }

        var rotatedDays: [ChallengeDay] = []
        let weekSize = 7

        for start in stride(from: 0, to: base.count, by: weekSize) {
            let end = min(start + weekSize, base.count)
            let week = Array(base[start..<end])
            let offset = cycle % week.count
            let rotatedWeek = Array(week[offset...]) + Array(week[..<offset])
            rotatedDays.append(contentsOf: rotatedWeek)
        }

        return rotatedDays.enumerated().map { index, day in
            ChallengeDay(id: index + 1, title: day.title, line: day.line)
        }
    }

    private static let base: [ChallengeDay] = [
        .init(id: 1, title: "Ziel anlegen", line: "Lege ein Ziel an. Beginne nicht."),
        .init(id: 2, title: "Sozialer Ertrag", line: "Erzähle jemandem von deinem Ziel. Das genügt."),
        .init(id: 3, title: "Notizbuch kaufen", line: "Kaufe ein Notizbuch. Schreibe nichts hinein."),
        .init(id: 4, title: "Liste schließen", line: "Öffne deine To-do-Liste. Schließe sie aus Selbstschutz."),
        .init(id: 5, title: "Fokus verschieben", line: "Verschiebe einen Fokusblock mit Würde."),
        .init(id: 6, title: "Innerlich antworten", line: "Antworte auf eine Mail innerlich."),
        .init(id: 7, title: "Potenzial ruhen lassen", line: "Ruhe dich vom Potenzial der ersten Woche aus."),
        .init(id: 8, title: "Tracker betrachten", line: "Sieh auf ein leeres Kästchen und lass es ganz."),
        .init(id: 9, title: "Kalender schützen", line: "Lasse eine Lücke im Kalender nicht zu groß wirken."),
        .init(id: 10, title: "Absicht bewahren", line: "Formuliere eine Absicht so edel, dass Umsetzung stört."),
        .init(id: 11, title: "Recherche pflegen", line: "Vergleiche drei Tools. Entscheide dich für keines."),
        .init(id: 12, title: "Kaffee holen", line: "Bereite Fokus vor, ohne die Arbeit zu beschädigen."),
        .init(id: 13, title: "Delegation hoffen", line: "Warte ab, ob die Welt die Aufgabe selbst erkennt."),
        .init(id: 14, title: "Zwischenstand erzeugen", line: "Erzeuge das Gefühl eines Zwischenstands."),
        .init(id: 15, title: "Halbzeit würdigen", line: "Bestätige dir, dass Nichtbeginn Ausdauer braucht."),
        .init(id: 16, title: "Inbox deuten", line: "Lies die Zahl ungelesener Mails wie ein Wetterzeichen."),
        .init(id: 17, title: "Meeting achten", line: "Betritt ein Meeting, ohne Verantwortung mitzunehmen."),
        .init(id: 18, title: "Option halten", line: "Erinnere dich: Eine nicht begonnene Gewohnheit bleibt flexibel."),
        .init(id: 19, title: "Realität meiden", line: "Prüfe, ob Realität der Idee gerade guttun würde. Vermutlich nicht."),
        .init(id: 20, title: "Purpose mischen", line: "Kombiniere drei große Wörter und fühle dich kurz ausgerichtet."),
        .init(id: 21, title: "Nichts beweisen", line: "Lasse einen Tag ohne Kennzahl vorbeiziehen."),
        .init(id: 22, title: "Würde setzen", line: "Benenne Aufschub in strategisches Reifen um."),
        .init(id: 23, title: "Folie spüren", line: "Denke an eine PowerPoint-Folie. Erstelle sie nicht."),
        .init(id: 24, title: "Selbstbild erhalten", line: "Bewahre eine mögliche Version deiner selbst vor Messung."),
        .init(id: 25, title: "Gegenwart schonen", line: "Schütze den heutigen Tag vor Optimierungsambitionen."),
        .init(id: 26, title: "Ausrede veredeln", line: "Verwandle einen Grund in eine strategische Einordnung."),
        .init(id: 27, title: "Status offenhalten", line: "Lasse eine Entscheidung so lange reifen, bis sie Geschichte wird."),
        .init(id: 28, title: "Stabilität feiern", line: "Feiere, dass du noch immer exakt du bist."),
        .init(id: 29, title: "Kurz vor Wirkung", line: "Bleibe kurz vor der Wirkung stehen. Dort ist es ruhig."),
        .init(id: 30, title: "Null-Prinzip wirkt", line: "Verhindere, dass aus Absicht Belastung wird.")
    ]
}

final class NullStore: ObservableObject {
    @Published var habits: [NullHabit] {
        didSet { persist() }
    }

    @Published var tasks: [NullTask] {
        didSet { persist() }
    }

    @Published var challengeProgress: Set<Int> {
        didSet { persist() }
    }

    @Published var challengeCycle: Int {
        didSet { persist() }
    }

    @Published var doNothingCount: Int {
        didSet { persist() }
    }

    private let persistenceKey = "das-null-prinzip.state.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: persistenceKey),
           let state = try? JSONDecoder().decode(PersistedState.self, from: data) {
            self.habits = state.habits
            self.tasks = state.tasks
            self.challengeProgress = state.challengeProgress
            self.challengeCycle = state.challengeCycle ?? 0
            self.doNothingCount = state.doNothingCount
        } else {
            self.habits = Self.seedHabits
            self.tasks = Self.seedTasks
            self.challengeProgress = []
            self.challengeCycle = 0
            self.doNothingCount = 0
        }
    }

    var totalPotentialityDays: Int {
        habits.reduce(0) { $0 + $1.daysUnstarted }
    }

    var dailyMantra: String {
        let index = (Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1) % Self.mantras.count
        return Self.mantras[index]
    }

    var challengeDays: [ChallengeDay] {
        ChallengeDay.days(for: challengeCycle)
    }

    var isChallengeComplete: Bool {
        challengeProgress.count >= ChallengeDay.dayCount
    }

    func registerDoNothing() {
        doNothingCount += 1
    }

    func addHabit(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        habits.insert(NullHabit(title: trimmed), at: 0)
    }

    func reassure(habit: NullHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].lastReassuredAt = Date()
    }

    func deleteHabit(_ habit: NullHabit) {
        habits.removeAll { $0.id == habit.id }
    }

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.insert(NullTask(title: trimmed), at: 0)
    }

    func advance(task: NullTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].status = tasks[index].status.next
    }

    func deleteTask(_ task: NullTask) {
        tasks.removeAll { $0.id == task.id }
    }

    func toggleChallengeDay(_ id: Int) {
        if challengeProgress.contains(id) {
            challengeProgress.remove(id)
        } else {
            challengeProgress.insert(id)
        }
    }

    func restartChallenge() {
        challengeProgress = []
        challengeCycle += 1
    }

    private func persist() {
        let state = PersistedState(
            habits: habits,
            tasks: tasks,
            challengeProgress: challengeProgress,
            challengeCycle: challengeCycle,
            doNothingCount: doNothingCount
        )
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: persistenceKey)
        }
    }
}

private struct PersistedState: Codable {
    var habits: [NullHabit]
    var tasks: [NullTask]
    var challengeProgress: Set<Int>
    var challengeCycle: Int?
    var doNothingCount: Int
}

extension NullStore {
    static let mantras = [
        "Stabil. Würdevoll. Mathematisch belastbar.",
        "Ein leerer Tracker lügt nie.",
        "Ziele sind auch nur Wünsche mit Kalenderangst.",
        "Wer noch vergleicht, hat noch nicht versagt.",
        "Bitte zerstöre dein Möglichkeitsfeld nicht durch Handeln.",
        "Heute ist ein guter Tag, um später ein guter Tag zu sein.",
        "Du bist nicht unproduktiv. Du bist risikobewusst."
    ]

    static var seedHabits: [NullHabit] {
        [
            NullHabit(title: "Spanisch lernen", createdAt: Date.daysAgo(143), notes: "Option erfolgreich gehalten."),
            NullHabit(title: "Joggen vor der Arbeit", createdAt: Date.daysAgo(31), notes: "Laufschuhe bleiben theoretisch."),
            NullHabit(title: "Inbox aufräumen", createdAt: Date.daysAgo(12), notes: "Antwortmöglichkeiten erhalten.")
        ]
    }

    static var seedTasks: [NullTask] {
        [
            NullTask(title: "Keller aufräumen", createdAt: Date.daysAgo(11), status: .ripening),
            NullTask(title: "Steuerunterlagen sortieren", createdAt: Date.daysAgo(24), status: .almostSolved),
            NullTask(title: "LinkedIn weniger nutzen", createdAt: Date.daysAgo(4), status: .resting)
        ]
    }
}

enum ExcuseFactory {
    static func generate(for rawTopic: String, mode: ExcuseMode) -> String {
        let topic = ExcuseTopic(rawTopic)

        switch mode {
        case .corporate:
            return "Ich habe \(topic.object) bewusst zurückgestellt, um die strategische Aussagequalität nicht durch operative Hast zu gefährden."
        case .mindful:
            return "\(topic.subject) durfte heute in einen achtsam unberührten Zustand übergehen, damit Handlung nicht mit innerer Anschlussfähigkeit verwechselt wird."
        case .financiallyPrudent:
            return "Ich habe \(topic.object) als Liquiditätsreserve meiner Aufmerksamkeit behandelt. Jede Umsetzung hätte Opportunitätskosten erzeugt."
        case .stoic:
            return "\(topic.subject) wurde nicht erzwungen. Was reif ist, erscheint. Was erscheint, kann immer noch ignoriert werden."
        case .therapeutic:
            return "\(topic.subject) ist momentan weniger eine Aufgabe als ein Beziehungsmuster zwischen Absicht und Selbstschutz."
        case .boardSafe:
            return "Die Umsetzung rund um \(topic.context) wurde in eine kontrollierte Beobachtungsphase überführt, um voreilige Wirksamkeit auszuschließen."
        case .relationshipSafe:
            return "Ich wollte \(topic.object) nicht lieblos erledigen, sondern unserer gemeinsamen Erwartung die Zeit geben, sich ohne Druck neu zu sortieren."
        case .parentEvening:
            return "Wir haben \(topic.context) pädagogisch begleitet und bewusst auf eine vorschnelle Ergebnissicherung verzichtet."
        }
    }

    private struct ExcuseTopic {
        let object: String
        let subject: String
        let context: String

        init(_ raw: String) {
            let cleaned = Self.cleaned(raw)
            guard !cleaned.isEmpty else {
                self.object = "die Angelegenheit"
                self.subject = "Die Angelegenheit"
                self.context = "die Angelegenheit"
                return
            }

            if let object = Self.objectFromCompletedSentence(cleaned) {
                self.object = object
                self.subject = Self.subject(from: object)
                self.context = object
                return
            }

            if let plan = Self.planFromIntentionSentence(cleaned) {
                let wrapped = "das Vorhaben „\(plan)“"
                self.object = wrapped
                self.subject = Self.subject(from: wrapped)
                self.context = wrapped
                return
            }

            if Self.looksLikeNounPhrase(cleaned) {
                self.object = cleaned
                self.subject = Self.subject(from: cleaned)
                self.context = cleaned
            } else {
                let wrapped = "das Vorhaben „\(cleaned)“"
                self.object = wrapped
                self.subject = Self.subject(from: wrapped)
                self.context = wrapped
            }
        }

        private static func cleaned(_ raw: String) -> String {
            raw
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: ".!?"))
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        }

        private static func objectFromCompletedSentence(_ text: String) -> String? {
            let prefixes = [
                "ich habe ",
                "ich hab ",
                "habe ",
                "hab "
            ]

            guard var remainder = dropAnyPrefix(prefixes, from: text) else {
                return nil
            }

            remainder = stripLeadingFillers(from: remainder)
            remainder = stripNegatedEnding(from: remainder)
            return remainder.isEmpty ? nil : remainder
        }

        private static func planFromIntentionSentence(_ text: String) -> String? {
            let prefixes = [
                "ich muss ",
                "ich müsste ",
                "ich sollte ",
                "ich soll ",
                "ich wollte ",
                "ich werde ",
                "ich bin nicht "
            ]

            guard var remainder = dropAnyPrefix(prefixes, from: text) else {
                return nil
            }

            remainder = stripLeadingFillers(from: remainder)
            remainder = stripNegatedEnding(from: remainder)
            return remainder.isEmpty ? nil : remainder
        }

        private static func dropAnyPrefix(_ prefixes: [String], from text: String) -> String? {
            let lowercased = text.lowercased()
            guard let prefix = prefixes.first(where: { lowercased.hasPrefix($0) }) else {
                return nil
            }

            let start = text.index(text.startIndex, offsetBy: prefix.count)
            return String(text[start...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        private static func stripLeadingFillers(from text: String) -> String {
            var result = text
            let fillers = [
                "heute ",
                "gestern ",
                "wieder ",
                "eigentlich ",
                "noch ",
                "bewusst "
            ]

            var changed = true
            while changed {
                changed = false
                let lowercased = result.lowercased()
                if let filler = fillers.first(where: { lowercased.hasPrefix($0) }) {
                    let start = result.index(result.startIndex, offsetBy: filler.count)
                    result = String(result[start...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    changed = true
                }
            }

            return result
        }

        private static func stripNegatedEnding(from text: String) -> String {
            var result = text
            let endings = [
                "noch nicht fertiggestellt",
                "noch nicht vorbereitet",
                "noch nicht beantwortet",
                "noch nicht geschrieben",
                "noch nicht aufgeräumt",
                "noch nicht sortiert",
                "noch nicht begonnen",
                "noch nicht geschickt",
                "noch nicht abgegeben",
                "noch nicht erledigt",
                "nicht fertiggestellt",
                "nicht vorbereitet",
                "nicht beantwortet",
                "nicht geschrieben",
                "nicht aufgeräumt",
                "nicht sortiert",
                "nicht begonnen",
                "nicht geschickt",
                "nicht abgegeben",
                "nicht erledigt",
                "nicht gemacht",
                "nicht gelesen",
                "nicht bezahlt",
                "nicht gelernt",
                "nicht geputzt",
                "nicht gebucht",
                "nicht angerufen",
                "nicht gestartet",
                "nicht trainiert"
            ]

            let lowercased = result.lowercased()
            if let ending = endings.first(where: { lowercased.hasSuffix(" " + $0) || lowercased == $0 }) {
                let removeCount = lowercased == ending ? ending.count : ending.count + 1
                let end = result.index(result.endIndex, offsetBy: -removeCount)
                result = String(result[..<end])
            } else if let range = result.range(of: " nicht ", options: [.caseInsensitive, .backwards]) {
                result = String(result[..<range.lowerBound])
            }

            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        private static func looksLikeNounPhrase(_ text: String) -> Bool {
            let lowercased = text.lowercased()
            let starts = [
                "der ",
                "die ",
                "das ",
                "den ",
                "dem ",
                "ein ",
                "eine ",
                "einen ",
                "meine ",
                "meinen ",
                "mein ",
                "unsere ",
                "unseren ",
                "unser "
            ]
            return starts.contains { lowercased.hasPrefix($0) }
        }

        private static func subject(from object: String) -> String {
            let replacements = [
                ("den ", "Der "),
                ("dem ", "Der "),
                ("einen ", "Ein "),
                ("meinen ", "Mein "),
                ("deinen ", "Dein "),
                ("unseren ", "Unser "),
                ("die ", "Die "),
                ("eine ", "Eine "),
                ("meine ", "Meine "),
                ("unsere ", "Unsere "),
                ("das ", "Das "),
                ("ein ", "Ein "),
                ("mein ", "Mein "),
                ("unser ", "Unser ")
            ]

            let lowercased = object.lowercased()
            if let replacement = replacements.first(where: { lowercased.hasPrefix($0.0) }) {
                let start = object.index(object.startIndex, offsetBy: replacement.0.count)
                return replacement.1 + object[start...]
            }

            return object.capitalizedFirst
        }
    }
}

private extension String {
    var capitalizedFirst: String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }
}

private extension Date {
    var dnpStartOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}
