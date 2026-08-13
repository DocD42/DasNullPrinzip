const nullQuotes = [
  "Nichts passiert. Das System wirkt.",
  "Ein weiterer Nullakt wurde dokumentiert.",
  "Die Produktivität blieb unbeschädigt.",
  "Der Tag wurde vor Ergebnissen geschützt.",
  "Wirklichkeit erfolgreich auf Distanz gehalten.",
  "Die Möglichkeit bleibt erhalten."
];

const doNothingButton = document.querySelector("#doNothingButton");
const doNothingCount = document.querySelector("#doNothingCount");
let nullActs = 0;

function renderNullActs() {
  let label = "Keine Nullakte";
  if (nullActs === 1) {
    label = "1 Nullakt";
  } else if (nullActs > 1) {
    label = `${nullActs} Nullakte`;
  }
  doNothingCount.textContent = label;
}

doNothingButton?.addEventListener("click", () => {
  nullActs += 1;
  doNothingButton.textContent = nullQuotes[nullActs % nullQuotes.length];
  renderNullActs();
});

renderNullActs();

const modes = {
  corporate: [
    "Ich habe {object} bewusst zurückgestellt, um die strategische Aussagequalität nicht durch operative Hast zu gefährden.",
    "Der Vorgang rund um {object} befindet sich in einer belastbaren Schwebephase.",
    "Ich habe {object} noch nicht operationalisiert, um keine künstliche Ergebnisnähe zu erzeugen."
  ],
  achtsam: [
    "{subject} durfte heute in einen achtsam unberührten Zustand übergehen.",
    "Ich habe {object} nicht vermieden, sondern innerlich weich gestellt.",
    "Die Energie um {object} war noch nicht bereit, mit Wirklichkeit belastet zu werden."
  ],
  paar: [
    "Ich wollte {object} nicht lieblos erledigen, sondern unserer gemeinsamen Erwartung die Zeit geben, sich ohne Druck neu zu sortieren.",
    "{subject} braucht zwischen uns keinen Druck, sondern einen emotional betreuten Schwebezustand.",
    "Ich habe {object} nicht abgelehnt, sondern vor vorschneller Erfüllung geschützt."
  ]
};

const fallbackObjects = [
  { object: "die Angelegenheit", subject: "Die Angelegenheit" },
  { object: "den Vorgang", subject: "Der Vorgang" },
  { object: "die Umsetzung", subject: "Die Umsetzung" },
  { object: "die Erwartung", subject: "Die Erwartung" }
];

function hashText(value) {
  let hash = 2166136261;
  for (const char of value) {
    hash ^= char.codePointAt(0);
    hash = Math.imul(hash, 16777619);
  }
  return Math.abs(hash);
}

function parseObject(value) {
  const cleaned = value.trim().replace(/[.!?]+$/g, "").replace(/\s+/g, " ");
  const lower = cleaned.toLowerCase();

  const patterns = [
    [/^ich habe (.+?) nicht (.+)$/i, 1],
    [/^ich werde (.+?) nicht (.+)$/i, 1],
    [/^ich kann (.+?) nicht (.+)$/i, 1],
    [/^(.+?) wurde nicht (.+)$/i, 1],
    [/^(.+?) ist nicht (.+)$/i, 1]
  ];

  for (const [regex, group] of patterns) {
    const match = cleaned.match(regex);
    if (!match) continue;
    const target = match[group].replace(/\bheute\b|\bmorgen\b|\bspäter\b|\bspater\b/gi, "").trim();
    const action = (match[group + 1] || "").toLowerCase();

    if (/^(dich|mich|uns|euch)\b/i.test(target) && /kuss|kuss|kuess|küss|gekuss|geküss|kussen|küssen/.test(action)) {
      return { object: lower.includes("heute") ? "den Kuss heute" : "den Kuss", subject: "Der Kuss" };
    }

    if (/^(der|die|das|den|dem|ein|eine|einen|mein|meine|meinen|dein|deine|deinen|unser|unsere|unseren)\s/i.test(target)) {
      return { object: target.replace(/^der\s/i, "den "), subject: capitalizeSubject(target) };
    }
  }

  const fallback = fallbackObjects[hashText(cleaned) % fallbackObjects.length];
  return fallback;
}

function capitalizeSubject(value) {
  const replacements = [
    [/^den\s/i, "Der "],
    [/^dem\s/i, "Der "],
    [/^einen\s/i, "Ein "],
    [/^meinen\s/i, "Mein "],
    [/^deinen\s/i, "Dein "]
  ];

  for (const [regex, replacement] of replacements) {
    if (regex.test(value)) return value.replace(regex, replacement);
  }

  return value.charAt(0).toUpperCase() + value.slice(1);
}

const input = document.querySelector("#excuseInput");
const output = document.querySelector("#excuseOutput");
const generateButton = document.querySelector("#generateExcuse");
const modeButtons = [...document.querySelectorAll(".mode-button")];
let activeMode = "corporate";

modeButtons.forEach((button) => {
  button.addEventListener("click", () => {
    activeMode = button.dataset.mode;
    modeButtons.forEach((item) => item.classList.toggle("active", item === button));
    generateExcuse();
  });
});

function generateExcuse() {
  const source = input.value || "Ich habe etwas nicht getan.";
  const parsed = parseObject(source);
  const options = modes[activeMode];
  const template = options[hashText(`${activeMode}|${source}`) % options.length];
  output.textContent = template
    .replaceAll("{object}", parsed.object)
    .replaceAll("{subject}", parsed.subject);
}

generateButton?.addEventListener("click", generateExcuse);
