import Foundation

enum NullIdeaStatus: String, CaseIterable, Codable, Identifiable {
    case pureIdea
    case considered
    case prepared
    case scheduled
    case started

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pureIdea: "Nur Idee"
        case .considered: "Schon bedacht"
        case .prepared: "Vorbereitet"
        case .scheduled: "Eingeplant"
        case .started: "Angefangen"
        }
    }

    var symbol: String {
        switch self {
        case .pureIdea: "lightbulb"
        case .considered: "eye"
        case .prepared: "tray"
        case .scheduled: "calendar"
        case .started: "play.circle"
        }
    }

    var next: NullIdeaStatus {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self), index < all.index(before: all.endIndex) else {
            return self
        }
        return all[all.index(after: index)]
    }

    var previous: NullIdeaStatus {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self), index > all.startIndex else {
            return self
        }
        return all[all.index(before: index)]
    }

    var score: Int {
        let rank = Self.allCases.firstIndex(of: self) ?? 0
        return rank * 25
    }

    var line: String {
        switch self {
        case .pureIdea: "Perfekt: Die Idee bleibt unversehrt im Kopf."
        case .considered: "Achtung: gedankliche Nähe zur Umsetzung."
        case .prepared: "Material ist schon gefährlich konkret."
        case .scheduled: "Ein Termin ist fast schon ein Tatort."
        case .started: "Akute Entfernung vom Null-Ideal."
        }
    }
}

struct NullHabit: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var status: NullIdeaStatus?
    var notes: String

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        status: NullIdeaStatus = .pureIdea,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.status = status
        self.notes = notes
    }

    var daysUnstarted: Int {
        Calendar.current.dateComponents([.day], from: createdAt.dnpStartOfDay, to: Date().dnpStartOfDay).day ?? 0
    }

    var currentStatus: NullIdeaStatus {
        status ?? .pureIdea
    }

    var deviation: Int {
        currentStatus.score
    }

    var canAdvance: Bool {
        currentStatus.next != currentStatus
    }

    var canRegress: Bool {
        currentStatus.previous != currentStatus
    }

    var milestone: String {
        guard currentStatus == .pureIdea else {
            return currentStatus.line
        }

        switch daysUnstarted {
        case 100...:
            return "Du hast bewiesen, dass kurzfristige Motivation an dir abperlt."
        case 30...:
            return "Diese Idee ist stabil nicht realisiert."
        case 7...:
            return "Weiterhin im Zustand reiner Potenzialität."
        default:
            return "Noch frisch. Bitte nicht durch Aktion gefährden."
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

    var previous: NullTaskStatus {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self), index > all.startIndex else {
            return self
        }
        return all[all.index(before: index)]
    }

    var rank: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

struct NullTask: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var status: NullTaskStatus
    var statusChangedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        status: NullTaskStatus = .new,
        statusChangedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.status = status
        self.statusChangedAt = statusChangedAt ?? createdAt
    }

    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: createdAt.dnpStartOfDay, to: Date().dnpStartOfDay).day ?? 0
    }

    var daysInCurrentStatus: Int {
        Calendar.current.dateComponents([.day], from: currentStatusStartedAt.dnpStartOfDay, to: Date().dnpStartOfDay).day ?? 0
    }

    var currentStatusStartedAt: Date {
        statusChangedAt ?? createdAt
    }

    var statusDurationLabel: String {
        switch daysInCurrentStatus {
        case 0:
            "seit heute"
        case 1:
            "seit 1 Tag"
        case 1..<30:
            "seit \(daysInCurrentStatus) Tagen"
        case 30..<60:
            "seit 1 Monat"
        case 60..<365:
            "seit \(daysInCurrentStatus / 30) Monaten"
        case 365..<730:
            "seit 1 Jahr"
        default:
            "seit \(daysInCurrentStatus / 365) Jahren"
        }
    }

    var statusDurationCompactLabel: String {
        switch daysInCurrentStatus {
        case 0:
            "heute"
        case 1..<30:
            "\(daysInCurrentStatus) T"
        case 30..<365:
            "\(max(1, daysInCurrentStatus / 30)) M"
        default:
            "\(max(1, daysInCurrentStatus / 365)) J"
        }
    }

    var ripenessAside: String {
        let seed = id.uuidString.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Self.ripenessAsides[seed % Self.ripenessAsides.count]
    }

    var hasGoldenPatina: Bool {
        daysInCurrentStatus >= 30
    }

    var canAdvance: Bool {
        status.next != status
    }

    var canRegress: Bool {
        status.previous != status
    }

    var ripeness: Int {
        let statusBase = 12 + status.rank * 12
        let timeBonus = min(18, daysInCurrentStatus / 2)
        let longTermBonus = min(10, ageInDays / 30)
        return min(94, max(6, statusBase + timeBonus + longTermBonus))
    }

    private static let ripenessAsides = [
        "Hat jemand nachgehakt?",
        "Blieb es still?",
        "Kam dazu noch Post?",
        "Wurde es vermisst?",
        "War es wirklich dringend?",
        "Rief die Realität an?",
        "Ist es schon Geschichte?",
        "Gab es echte Gefahr?"
    ]
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
            self.tasks = Self.tasksWithPreviewPatina(state.tasks)
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

    private static func tasksWithPreviewPatina(_ tasks: [NullTask]) -> [NullTask] {
        var updatedTasks = tasks
        guard let index = updatedTasks.firstIndex(where: { $0.title == "Steuerunterlagen sortieren" }),
              updatedTasks[index].statusChangedAt == nil else {
            return updatedTasks
        }

        updatedTasks[index].createdAt = Date.daysAgo(43)
        updatedTasks[index].statusChangedAt = Date.daysAgo(32)
        return updatedTasks
    }

    var totalPotentialityDays: Int {
        habits.reduce(0) { $0 + $1.daysUnstarted }
    }

    var trackerDeviationScore: Int {
        averageScore(habits.map(\.deviation))
    }

    var ripeningDeviationScore: Int {
        averageScore(tasks.map(\.ripeness))
    }

    var totalDeviationScore: Int {
        var scores: [Int] = []
        if !habits.isEmpty { scores.append(trackerDeviationScore) }
        if !tasks.isEmpty { scores.append(ripeningDeviationScore) }
        return averageScore(scores)
    }

    private func averageScore(_ scores: [Int]) -> Int {
        guard !scores.isEmpty else { return 0 }
        let total = scores.reduce(0, +)
        return Int((Double(total) / Double(scores.count)).rounded())
    }

    var dailyMantra: String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (day + doNothingCount) % Self.mantras.count
        return Self.mantras[index]
    }

    var doNothingRankTitle: String {
        Self.doNothingLevel(for: doNothingCount).title
    }

    var doNothingRankDetail: String {
        guard let nextTarget = Self.nextDoNothingTarget(after: doNothingCount) else {
            return "Weitere Klicks werden selbstverständlich entgegengenommen, aber nicht überbewertet."
        }

        let missing = nextTarget - doNothingCount
        let pluralizedClick = missing == 1 ? "Klick" : "Klicks"
        return "Noch \(missing) \(pluralizedClick) bis: \(Self.doNothingLevel(for: nextTarget).title)."
    }

    var doNothingLevelProgress: Int {
        guard let nextTarget = Self.nextDoNothingTarget(after: doNothingCount) else { return 100 }
        let previousTarget = Self.previousDoNothingTarget(before: nextTarget)
        let span = max(1, nextTarget - previousTarget)
        let current = max(0, doNothingCount - previousTarget)
        return min(100, Int((Double(current) / Double(span) * 100).rounded()))
    }

    var doNothingConfirmation: String {
        if doNothingCount == 1 {
            return "Der erste Nullakt wurde ohne erkennbare Folgen verbucht."
        }

        return "\(doNothingCount) Nullakte. \(doNothingRankTitle) bleibt aktenkundig."
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

    func advanceIdea(_ habit: NullHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        guard habits[index].canAdvance else { return }
        habits[index].status = habits[index].currentStatus.next
    }

    func regressIdea(_ habit: NullHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        guard habits[index].canRegress else { return }
        habits[index].status = habits[index].currentStatus.previous
    }

    func resetIdea(_ habit: NullHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].status = .pureIdea
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
        guard tasks[index].canAdvance else { return }
        tasks[index].status = tasks[index].status.next
        tasks[index].statusChangedAt = Date()
    }

    func regress(task: NullTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        guard tasks[index].canRegress else { return }
        tasks[index].status = tasks[index].status.previous
        tasks[index].statusChangedAt = Date()
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
        "Du bist nicht unproduktiv. Du bist risikobewusst.",
        "Jeder Anfang ist ein unnötiges Risiko.",
        "Die Lage bleibt unterlassungssicher.",
        "Nichtstun ist auch eine Form der Datenpflege."
    ]

    private static let doNothingLevels: [(target: Int, title: String)] = [
        (0, "Noch unberührt"),
        (1, "Erster Nullakt"),
        (3, "Stabile Inaktivität"),
        (7, "Wöchentliche Auslassung"),
        (14, "Amtlich ausbleibend"),
        (30, "Null-Routine"),
        (50, "Fortgeschrittene Wirkungslosigkeit"),
        (100, "Meisterklasse der Auslassung")
    ]

    private static func doNothingLevel(for count: Int) -> (target: Int, title: String) {
        doNothingLevels.last(where: { count >= $0.target }) ?? doNothingLevels[0]
    }

    private static func nextDoNothingTarget(after count: Int) -> Int? {
        doNothingLevels.first(where: { count < $0.target })?.target
    }

    private static func previousDoNothingTarget(before target: Int) -> Int {
        doNothingLevels.last(where: { $0.target < target })?.target ?? 0
    }

    static var seedHabits: [NullHabit] {
        [
            NullHabit(title: "Spanisch lernen", createdAt: Date.daysAgo(143), notes: "Option erfolgreich gehalten."),
            NullHabit(title: "Joggen vor der Arbeit", createdAt: Date.daysAgo(31), notes: "Laufschuhe bleiben theoretisch."),
            NullHabit(title: "Inbox aufräumen", createdAt: Date.daysAgo(12), notes: "Antwortmöglichkeiten erhalten.")
        ]
    }

    static var seedTasks: [NullTask] {
        [
            NullTask(title: "Keller aufräumen", createdAt: Date.daysAgo(11), status: .ripening, statusChangedAt: Date.daysAgo(6)),
            NullTask(title: "Steuerunterlagen sortieren", createdAt: Date.daysAgo(43), status: .almostSolved, statusChangedAt: Date.daysAgo(32)),
            NullTask(title: "LinkedIn weniger nutzen", createdAt: Date.daysAgo(4), status: .resting, statusChangedAt: Date.daysAgo(2))
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

            if let object = Self.objectFromAbsenceSentence(cleaned) {
                self.object = object
                self.subject = Self.subject(from: object)
                self.context = object
                return
            }

            if let object = Self.objectFromCompletedSentence(cleaned) {
                self.object = object
                self.subject = Self.subject(from: object)
                self.context = object
                return
            }

            if let plan = Self.planFromIntentionSentence(cleaned) {
                if Self.looksLikeNounPhrase(plan) {
                    self.object = plan
                    self.subject = Self.subject(from: plan)
                    self.context = plan
                } else {
                    let wrapped = "das Vorhaben „\(plan)“"
                    self.object = wrapped
                    self.subject = Self.subject(from: wrapped)
                    self.context = wrapped
                }
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

        private static func objectFromAbsenceSentence(_ text: String) -> String? {
            let patterns: [(prefix: String, suffixes: [String])] = [
                ("ich kann ", [" nicht kommen", " nicht teilnehmen", " nicht erscheinen", " nicht da sein", " nicht dabei sein"]),
                ("ich werde ", [" nicht kommen", " nicht teilnehmen", " nicht erscheinen", " nicht da sein", " nicht dabei sein"]),
                ("ich komme ", [" nicht"]),
                ("ich erscheine ", [" nicht"]),
                ("ich nehme ", [" nicht teil"]),
                ("ich bin ", [" nicht da", " nicht dabei", " verhindert"]),
                ("ich schaffe es ", [" nicht"])
            ]

            for pattern in patterns {
                for suffix in pattern.suffixes {
                    guard let context = textBetween(prefix: pattern.prefix, suffix: suffix, in: text) else {
                        continue
                    }

                    let cleanedContext = stripAbsenceFillers(from: context)
                    guard !hasTaskObject(in: cleanedContext) else {
                        continue
                    }

                    return absenceObject(for: cleanedContext)
                }
            }

            return nil
        }

        private static func planFromIntentionSentence(_ text: String) -> String? {
            let prefixes = [
                "ich kann ",
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

        private static func textBetween(prefix: String, suffix: String, in text: String) -> String? {
            let lowercased = text.lowercased()
            guard lowercased.hasPrefix(prefix), lowercased.hasSuffix(suffix) else {
                return nil
            }

            let start = text.index(text.startIndex, offsetBy: prefix.count)
            let end = text.index(text.endIndex, offsetBy: -suffix.count)
            guard start <= end else { return nil }
            return String(text[start..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
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

        private static func stripAbsenceFillers(from text: String) -> String {
            var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let leadingFillers = [
                "leider ",
                "eigentlich ",
                "wahrscheinlich ",
                "vermutlich ",
                "wohl ",
                "doch ",
                "wirklich "
            ]
            let trailingFillers = [
                " leider",
                " eigentlich",
                " wahrscheinlich",
                " vermutlich",
                " wohl",
                " doch",
                " wirklich"
            ]

            var changed = true
            while changed {
                changed = false
                let lowercased = result.lowercased()
                if let filler = leadingFillers.first(where: { lowercased.hasPrefix($0) }) {
                    let start = result.index(result.startIndex, offsetBy: filler.count)
                    result = String(result[start...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    changed = true
                    continue
                }

                if let filler = trailingFillers.first(where: { lowercased.hasSuffix($0) }) {
                    let end = result.index(result.endIndex, offsetBy: -filler.count)
                    result = String(result[..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
                    changed = true
                }
            }

            return result
        }

        private static func hasTaskObject(in text: String) -> Bool {
            looksLikeNounPhrase(text)
        }

        private static func absenceObject(for context: String) -> String {
            guard !context.isEmpty else {
                return "meine Teilnahme"
            }

            return "meine Teilnahme \(context)"
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
                "nicht trainiert",
                "nicht fertigstellen",
                "nicht vorbereiten",
                "nicht beantworten",
                "nicht schreiben",
                "nicht aufräumen",
                "nicht sortieren",
                "nicht beginnen",
                "nicht schicken",
                "nicht abgeben",
                "nicht erledigen",
                "nicht machen",
                "nicht lesen",
                "nicht bezahlen",
                "nicht lernen",
                "nicht putzen",
                "nicht buchen",
                "nicht anrufen",
                "nicht starten",
                "nicht trainieren"
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
                "deine ",
                "deinen ",
                "dein ",
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
                ("deine ", "Deine "),
                ("meine ", "Meine "),
                ("unsere ", "Unsere "),
                ("das ", "Das "),
                ("dein ", "Dein "),
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
