import SwiftUI
import AppKit
import Carbon.HIToolbox
import Combine
import CryptoKit
import ServiceManagement
import UniformTypeIdentifiers
import Security

// MARK: - Bahasa antarmuka

enum Lang: String, CaseIterable, Identifiable {
    case idn = "id"
    case en = "en"
    var id: String { rawValue }
}

let strings: [String: (String, String)] = [
    "search": ("Cari...  (#label untuk filter kategori)", "Search...  (#label to filter by category)"),
    "copy_btn": ("Salin", "Copy"),
    "copy_all": ("Salin semua", "Copy all"),
    "cmd_n": ("%d command", "%d commands"),
    "switch_cmd": ("pindah command", "switch command"),
    "ed_add_cmd": ("Tambah command", "Add command"),
    "f_label": ("Label (opsional), mis. Ekstrak", "Label (optional), e.g. Extract"),
    "edit_short": ("edit", "edit"),
    "no_results_for": ("Tidak ada hasil untuk “%@”", "No results for “%@”"),
    "create_from": ("Buat cheatsheet “%@”", "Create cheatsheet “%@”"),
    "empty_title": ("Belum ada cheatsheet", "No cheatsheets yet"),
    "empty_select": ("Pilih cheatsheet untuk melihat detail", "Select a cheatsheet to see details"),
    "delete_q": ("Hapus “%@”?", "Delete “%@”?"),
    "fill_title": ("Isi placeholder", "Fill placeholders"),
    "copy_raw": ("Salin apa adanya", "Copy as-is"),
    "placeholder_hint": ("Pakai {{nama}}, {{nama:default}}, atau {{nama:a|b|c}} (saran, yang pertama jadi default) untuk isian saat menyalin.",
                         "Use {{name}}, {{name:default}} or {{name:a|b|c}} (suggestions, the first is the default) for values filled in when copying."),
    "sec_suggest": ("Saran placeholder", "Placeholder suggestions"),
    "suggest_desc": ("Satu baris per nama: nama = nilai1, nilai2. Berlaku untuk semua cheatsheet yang memakai {{nama}}.",
                     "One line per name: name = value1, value2. Applies to every cheatsheet that uses {{name}}."),
    "clear_recent": ("Hapus riwayat isian", "Clear recent values"),
    "recent_cleared": ("Riwayat isian dihapus.", "Recent values cleared."),
    "recent": ("terakhir", "recent"),
    "fill_hint": ("⏎ berikutnya   ⇥ pakai saran   ⌥1–9 pilih saran   ⌘⏎ salin",
                  "⏎ next   ⇥ accept suggestion   ⌥1–9 pick suggestion   ⌘⏎ copy"),
    "view_all": ("Lihat semua (%d baris)", "View all (%d lines)"),
    "view_less": ("Ringkas", "Show less"),
    "expand": ("Perluas", "Expand"),
    "collapse": ("Perkecil", "Collapse"),
    "ed_placeholders": ("Deskripsi placeholder", "Placeholder descriptions"),
    "ph_desc": ("Deskripsi (opsional), mis. namespace tujuan deploy", "Description (optional), e.g. target namespace"),
    "hide_preview": ("Sembunyikan pratinjau", "Hide preview"),
    "show_preview": ("Tampilkan pratinjau", "Show preview"),
    "placeholders": ("Isian", "Placeholders"),
    "used_n": ("disalin %d×", "copied %d×"),
    "hotkey_tip": ("Hotkey global: %@  ·  ⌘, pengaturan  ·  esc hapus pencarian / tutup",
                   "Global hotkey: %@  ·  ⌘, settings  ·  esc clears search / closes"),
    "all": ("Semua", "All"),
    "more": ("Lainnya", "More"),
    "less": ("Ringkas", "Less"),
    "select": ("pilih", "select"),
    "copy": ("salin", "copy"),
    "add": ("tambah", "add"),
    "settings_short": ("pengaturan", "settings"),
    "close": ("tutup", "close"),
    "notes_count": ("entri", "entries"),
    "no_results": ("Tidak ada hasil", "No results"),
    "copied": ("Disalin", "Copied"),
    "pin_on": ("Lepas pin (auto hide)", "Unpin (auto hide)"),
    "pin_off": ("Sematkan agar tidak hilang", "Pin so it stays visible"),
    "add_help": ("Cheatsheet baru (⌘N)", "New cheatsheet (⌘N)"),
    "settings": ("Pengaturan", "Settings"),
    "edit": ("Edit", "Edit"),
    "delete": ("Hapus", "Delete"),
    "ed_new_cheat": ("Cheatsheet baru", "New cheatsheet"),
    "ed_preview": ("Pratinjau", "Preview"),
    "loading": ("Memuat...", "Loading..."),
    "showing": ("Menampilkan", "Showing"),
    "preview_more_lines": ("%d baris lagi, tersalin utuh saat disalin", "%d more lines, copied in full when copied"),
    "preview_truncated": ("dipotong, tersalin utuh saat disalin", "truncated, copied in full when copied"),
    "f_title": ("Judul", "Title"),
    "f_category": ("Tambah label, Enter atau koma", "Add label, Enter or comma"),
    "f_command": ("Command", "Command"),
    "f_detail": ("Keterangan", "Description"),
    "cancel": ("Batal", "Cancel"),
    "save": ("Simpan", "Save"),
    "back": ("Kembali", "Back"),
    "sec_data": ("Data", "Data"),
    "data_note": ("Cheatsheet disimpan lokal di Mac ini sebagai JSON.",
                  "Cheatsheets are stored locally on this Mac as JSON."),
    "export": ("Ekspor...", "Export..."),
    "import": ("Impor...", "Import..."),
    "open_finder": ("Buka di Finder", "Show in Finder"),
    "export_ok": ("%d cheatsheet diekspor.", "%d cheatsheets exported."),
    "export_fail": ("Gagal mengekspor: ", "Export failed: "),
    "import_fail": ("File tidak bisa dibaca sebagai cheatsheet.", "File could not be read as cheatsheets."),
    "import_ok": ("%d cheatsheet diimpor.", "%d cheatsheets imported."),
    "import_q": ("Impor %d cheatsheet", "Import %d cheatsheets"),
    "import_q_desc": ("Gabung: tambahkan ke data sekarang (entri dengan ID sama diperbarui). Ganti: hapus semua data sekarang lalu pakai isi file.",
                      "Merge: add to current data (entries with the same ID are updated). Replace: delete all current data and use the file contents."),
    "merge": ("Gabung", "Merge"),
    "replace": ("Ganti semua", "Replace all"),
    "sec_hotkey": ("Hotkey", "Hotkey"),
    "toggle_panel": ("Tampilkan / sembunyikan panel", "Show / hide panel"),
    "press_keys": ("Tekan kombinasi...", "Press keys..."),
    "reset": ("Reset", "Reset"),
    "hotkey_hint": ("Klik tombol, lalu tekan kombinasi baru. Wajib ada modifier (⌃ ⌥ ⇧ ⌘). Esc untuk batal.",
                    "Click the button, then press the new combination. A modifier (⌃ ⌥ ⇧ ⌘) is required. Esc cancels."),
    "need_modifier": ("Tambahkan minimal satu modifier.", "Add at least one modifier."),
    "sec_general": ("Umum", "General"),
    "bg": ("Jalan di background", "Run in background"),
    "bg_desc": ("Kalau mati, aplikasi keluar saat panel ditutup dan hotkey tidak aktif.",
                "If off, the app quits when the panel is closed and the hotkey is inactive."),
    "hide_icon": ("Sembunyikan ikon di menu bar", "Hide menu bar icon"),
    "hide_icon_desc": ("Panel tetap bisa dibuka lewat hotkey atau dengan membuka ulang aplikasi dari Finder.",
                       "You can still open the panel with the hotkey or by reopening the app from Finder."),
    "login": ("Buka saat login", "Open at login"),
    "login_desc": ("Paling andal kalau aplikasi ada di folder Applications.",
                   "Most reliable when the app is in the Applications folder."),
    "sec_lang": ("Bahasa", "Language"),
    "language": ("Bahasa", "Language"),
    "menu_toggle": ("Tampilkan / Sembunyikan", "Show / Hide"),
    "menu_pin": ("Sematkan di atas", "Keep on top"),
    "menu_settings": ("Pengaturan...", "Settings..."),
    "menu_export": ("Ekspor cheatsheet...", "Export cheatsheets..."),
    "menu_import": ("Impor cheatsheet...", "Import cheatsheets..."),
    "menu_open": ("Buka folder data", "Open data folder"),
    "menu_quit": ("Keluar", "Quit"),
    "sec_backup": ("Backup iCloud", "iCloud backup"),
    "backup_desc": ("Salinan otomatis ke iCloud Drive, terpisah dari data harian di Mac ini. Menyimpan 5 backup terakhir.",
                     "Automatic copies to iCloud Drive, separate from the daily data on this Mac. Keeps the last 5 backups."),
    "backup_off": ("Nonaktif", "Off"),
    "backup_daily": ("Harian", "Daily"),
    "backup_weekly": ("Mingguan", "Weekly"),
    "backup_now": ("Backup sekarang", "Back up now"),
    "backup_restore": ("Pulihkan...", "Restore..."),
    "backup_unavailable": ("iCloud Drive tidak ditemukan. Aktifkan di System Settings > Apple ID > iCloud Drive.",
                           "iCloud Drive not found. Turn it on in System Settings > Apple ID > iCloud Drive."),
    "backup_ok": ("Backup tersimpan di iCloud.", "Backup saved to iCloud."),
    "backup_fail": ("Backup gagal: ", "Backup failed: "),
    "backup_last": ("Terakhir: %@", "Last: %@"),
    "backup_none": ("Belum ada backup.", "No backups yet."),
    "backup_pick_title": ("Pilih backup untuk dipulihkan", "Choose a backup to restore"),
    "backup_restore_q": ("Pulihkan dari %@?", "Restore from %@?")
]

func t(_ key: String) -> String {
    guard let v = strings[key] else { return key }
    return Settings.shared.language == .idn ? v.0 : v.1
}

/// t() dengan satu argumen pengganti %@ atau %d
func t(_ key: String, _ arg: Any) -> String {
    t(key).replacingOccurrences(of: "%@", with: "\(arg)").replacingOccurrences(of: "%d", with: "\(arg)")
}

// MARK: - Settings

enum BackupInterval: String, CaseIterable, Identifiable {
    case off, daily, weekly
    var id: String { rawValue }
    var label: String {
        switch self {
        case .off: return t("backup_off")
        case .daily: return t("backup_daily")
        case .weekly: return t("backup_weekly")
        }
    }
    /// nil berarti tidak pernah otomatis
    var seconds: TimeInterval? {
        switch self {
        case .off: return nil
        case .daily: return 86_400
        case .weekly: return 7 * 86_400
        }
    }
}

final class Settings: ObservableObject {
    static let shared = Settings()
    private let d = UserDefaults.standard

    @Published var hotkeyCode: Int { didSet { d.set(hotkeyCode, forKey: "hotkeyCode") } }
    @Published var hotkeyMods: Int { didSet { d.set(hotkeyMods, forKey: "hotkeyMods") } }
    @Published var hotkeyLabel: String { didSet { d.set(hotkeyLabel, forKey: "hotkeyLabel") } }
    @Published var runInBackground: Bool { didSet { d.set(runInBackground, forKey: "runInBackground") } }
    @Published var hideMenuIcon: Bool { didSet { d.set(hideMenuIcon, forKey: "hideMenuIcon") } }
    @Published var language: Lang { didSet { d.set(language.rawValue, forKey: "language") } }
    @Published var placeholderRules: String { didSet { d.set(placeholderRules, forKey: "placeholderRules") } }
    @Published var backupInterval: BackupInterval { didSet { d.set(backupInterval.rawValue, forKey: "backupInterval") } }
    @Published var lastBackupAt: Date? { didSet { d.set(lastBackupAt, forKey: "lastBackupAt") } }

    init() {
        hotkeyCode = d.object(forKey: "hotkeyCode") as? Int ?? kVK_Space
        hotkeyMods = d.object(forKey: "hotkeyMods") as? Int ?? (controlKey | optionKey)
        hotkeyLabel = d.string(forKey: "hotkeyLabel") ?? "⌃⌥Space"
        runInBackground = d.object(forKey: "runInBackground") as? Bool ?? true
        hideMenuIcon = d.object(forKey: "hideMenuIcon") as? Bool ?? false
        language = Lang(rawValue: d.string(forKey: "language") ?? "") ?? .idn
        placeholderRules = d.string(forKey: "placeholderRules") ?? "namespace = default, kube-system"
        backupInterval = BackupInterval(rawValue: d.string(forKey: "backupInterval") ?? "") ?? .daily
        lastBackupAt = d.object(forKey: "lastBackupAt") as? Date
    }

    func resetHotkey() {
        hotkeyCode = kVK_Space
        hotkeyMods = controlKey | optionKey
        hotkeyLabel = "⌃⌥Space"
    }
}

// MARK: - Migrasi data lama (versi terenkripsi, read-only)

/// Versi sebelumnya menyimpan notes-<timestamp>.cheat terenkripsi (AES-GCM + LZFSE),
/// kadang di folder cloud. Ini hanya dipakai sekali untuk membaca data lama ke format JSON lokal.
enum LegacyImport {
    static func candidateDirs() -> [URL] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        let d = UserDefaults.standard
        var dirs = [Store.localDir]
        if let custom = d.string(forKey: "customFolder"), !custom.isEmpty {
            dirs.append(URL(fileURLWithPath: custom, isDirectory: true))
        }
        dirs.append(home.appendingPathComponent("Library/Mobile Documents/com~apple~CloudDocs/CheatSheet"))
        let cloud = home.appendingPathComponent("Library/CloudStorage")
        for name in (try? fm.contentsOfDirectory(atPath: cloud.path)) ?? []
        where name.hasPrefix("GoogleDrive") || name.hasPrefix("OneDrive") {
            let root = cloud.appendingPathComponent(name)
            for sub in ["My Drive/CheatSheet", "Drive Saya/CheatSheet", "CheatSheet"] {
                dirs.append(root.appendingPathComponent(sub))
            }
        }
        return dirs
    }

    static func key() -> SymmetricKey? {
        let q: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: "local.cheatsheet.app",
                                kSecAttrAccount as String: "notes-key",
                                kSecReturnData as String: true,
                                kSecMatchLimit as String: kSecMatchLimitOne]
        var out: AnyObject?
        var data: Data?
        if SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess { data = out as? Data }
        if data == nil { data = try? Data(contentsOf: Store.localDir.appendingPathComponent(".key")) }
        guard let k = data, k.count == 32 else { return nil }
        return SymmetricKey(data: k)
    }

    static func decrypt(_ blob: Data, key: SymmetricKey) -> Data? {
        let v1 = Data("CSHT1".utf8), v2 = Data("CSHT2".utf8)
        let compressed = blob.starts(with: v2)
        guard compressed || blob.starts(with: v1),
              let box = try? AES.GCM.SealedBox(combined: blob.dropFirst(v1.count)),
              let raw = try? AES.GCM.open(box, using: key) else { return nil }
        return compressed ? (try? (raw as NSData).decompressed(using: .lzfse) as Data) : raw
    }

    enum Result { case notes([Note]), unreadable, none }

    /// .unreadable kalau ada file lama tapi gagal dibaca (mis. akses Keychain ditolak)
    static func load() -> Result {
        let fm = FileManager.default
        let plain = Store.localDir.appendingPathComponent("notes.json")
        var files: [URL] = []
        for dir in candidateDirs() {
            let items = (try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
            files += items.filter { $0.lastPathComponent.hasPrefix("notes-") && $0.pathExtension == "cheat" }
        }
        files.sort { $0.lastPathComponent > $1.lastPathComponent }
        if !files.isEmpty, let k = key() {
            for f in files {
                if let blob = try? Data(contentsOf: f), let json = decrypt(blob, key: k),
                   let n = try? JSONDecoder().decode([Note].self, from: json) { return .notes(n) }
            }
        }
        if let data = try? Data(contentsOf: plain), let n = try? JSONDecoder().decode([Note].self, from: data) {
            return .notes(n)
        }
        return files.isEmpty ? .none : .unreadable
    }
}

// MARK: - Syntax highlighter

enum Tok: UInt8 {
    case plain = 0, comment, string, keyword, number, builtin, variable, key, flag
}

struct LangDef {
    var primary: [(String, Tok)]      // dipindai kiri ke kanan: komentar dan string
    var secondary: [(String, Tok)]    // hanya mewarnai karakter yang belum terwarnai
    var ci = false
}

final class CompiledLang {
    let primary: NSRegularExpression?
    let primaryKinds: [Tok]
    let secondary: [(NSRegularExpression, Tok)]

    init(_ d: LangDef) {
        var opts: NSRegularExpression.Options = [.anchorsMatchLines]
        if d.ci { opts.insert(.caseInsensitive) }
        if d.primary.isEmpty {
            primary = nil
        } else {
            let joined = d.primary.map { "(\($0.0))" }.joined(separator: "|")
            primary = try? NSRegularExpression(pattern: joined, options: opts)
        }
        primaryKinds = d.primary.map { $0.1 }
        secondary = d.secondary.compactMap { p in
            guard let re = try? NSRegularExpression(pattern: p.0, options: opts) else { return nil }
            return (re, p.1)
        }
    }
}

enum Highlighter {
    static let languages = ["bash", "yaml", "python", "json", "sql", "javascript", "dockerfile", "toml", "text"]

    static func canonical(_ l: String) -> String {
        switch l.lowercased() {
        case "sh", "shell", "zsh", "bash": return "bash"
        case "yml", "yaml": return "yaml"
        case "py", "python": return "python"
        case "js", "ts", "javascript", "typescript": return "javascript"
        case "ini", "toml": return "toml"
        case "json": return "json"
        case "sql": return "sql"
        case "dockerfile": return "dockerfile"
        default: return "text"
        }
    }

    // Catatan: \x22 adalah tanda kutip ganda, \x27 adalah tanda kutip tunggal.
    static let defs: [String: LangDef] = [
        "bash": LangDef(
            primary: [
                (##"(?:^|(?<=\s))#[^\n]*"##, .comment),
                (##"\x22(?:\\.|[^\x22\\])*\x22"##, .string),
                (##"\x27[^\x27]*\x27"##, .string)
            ],
            secondary: [
                (##"\$\{[^}\n]*\}|\$[A-Za-z_][A-Za-z0-9_]*|\$[0-9@#?*!]"##, .variable),
                (##"(?<=\s)--?[A-Za-z][A-Za-z0-9_-]*"##, .flag),
                (##"\b(?:if|then|else|elif|fi|for|while|until|do|done|case|esac|in|function|select|return|exit|break|continue|local|export|readonly|declare|unset|source|alias|set|shift|trap|eval|exec)\b"##, .keyword),
                (##"\b(?:sudo|ls|cd|cp|mv|rm|mkdir|rmdir|cat|grep|egrep|sed|awk|find|xargs|tar|gzip|gunzip|zip|unzip|curl|wget|ssh-copy-id|ssh|scp|rsync|chmod|chown|chgrp|ps|kill|pkill|top|df|du|free|systemctl|journalctl|docker|podman|kubectl|oc|helm|git|make|echo|printf|read|test|tee|sort|uniq|head|tail|wc|cut|tr|touch|ln|mount|umount|ip|ss|nc|dig|ping|traceroute|apt-get|apt|yum|dnf|rpm|pip|npm|ansible-playbook|ansible|terraform|openssl|nslookup|lsblk|iostat|vmstat|nmap|tcpdump|lsof|crontab|adduser|useradd|usermod|passwd|su|whoami|hostname|uname|date|env|which|man|vi|vim|nano|id)\b"##, .builtin),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ]),
        "yaml": LangDef(
            primary: [
                (##"(?:^|(?<=\s))#[^\n]*"##, .comment),
                (##"\x22(?:\\.|[^\x22\\\n])*\x22"##, .string),
                (##"\x27[^\x27\n]*\x27"##, .string)
            ],
            secondary: [
                (##"^(?:---|\.\.\.)\s*$"##, .keyword),
                (##"(?<=^|[\s-])[A-Za-z0-9_./-]+(?=\s*:(?:\s|$))"##, .key),
                (##"\{\{[^}\n]*\}\}|\$\{[^}\n]*\}|[&*][A-Za-z0-9_-]+"##, .variable),
                (##"\b(?:true|false|null|yes|no|True|False|Null)\b"##, .keyword),
                (##"(?<![\w.])-?\d+(?:\.\d+)?(?![\w.])"##, .number)
            ]),
        "python": LangDef(
            primary: [
                (##"\x22\x22\x22[\s\S]*?\x22\x22\x22"##, .string),
                (##"\x27\x27\x27[\s\S]*?\x27\x27\x27"##, .string),
                (##"#[^\n]*"##, .comment),
                (##"[fFrRbB]{0,2}\x22(?:\\.|[^\x22\\\n])*\x22"##, .string),
                (##"[fFrRbB]{0,2}\x27(?:\\.|[^\x27\\\n])*\x27"##, .string)
            ],
            secondary: [
                (##"(?<=\bdef\s)[A-Za-z_]\w*|(?<=\bclass\s)[A-Za-z_]\w*"##, .key),
                (##"(?<![\w.])@[A-Za-z_][\w.]*"##, .variable),
                (##"\b(?:def|class|return|if|elif|else|for|while|in|not|and|or|is|import|from|as|with|try|except|finally|raise|pass|break|continue|lambda|yield|global|nonlocal|assert|del|async|await|None|True|False|self)\b"##, .keyword),
                (##"\b(?:print|len|range|open|str|int|float|list|dict|set|tuple|bool|type|isinstance|enumerate|zip|map|filter|sorted|sum|min|max|abs|any|all|super|input|sys|os|json|re|subprocess|requests)\b"##, .builtin),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ]),
        "json": LangDef(
            primary: [
                (##"\x22(?:\\.|[^\x22\\\n])*\x22(?=\s*:)"##, .key),
                (##"\x22(?:\\.|[^\x22\\\n])*\x22"##, .string)
            ],
            secondary: [
                (##"\b(?:true|false|null)\b"##, .keyword),
                (##"-?\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b"##, .number)
            ]),
        "sql": LangDef(
            primary: [
                (##"--[^\n]*"##, .comment),
                (##"/\*[\s\S]*?\*/"##, .comment),
                (##"\x27(?:\x27\x27|[^\x27])*\x27"##, .string)
            ],
            secondary: [
                (##"\b(?:select|from|where|and|or|not|insert|into|values|update|set|delete|create|table|alter|drop|index|join|left|right|inner|outer|on|group|by|order|having|limit|offset|as|distinct|union|all|null|is|in|like|between|case|when|then|else|end|primary|key|foreign|references|default|with|exists)\b"##, .keyword),
                (##"\b(?:count|sum|avg|min|max|now|coalesce|lower|upper|length|concat)(?=\s*\()"##, .builtin),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ],
            ci: true),
        "javascript": LangDef(
            primary: [
                (##"//[^\n]*"##, .comment),
                (##"/\*[\s\S]*?\*/"##, .comment),
                (##"`(?:\\.|[^`\\])*`"##, .string),
                (##"\x22(?:\\.|[^\x22\\\n])*\x22"##, .string),
                (##"\x27(?:\\.|[^\x27\\\n])*\x27"##, .string)
            ],
            secondary: [
                (##"\b(?:const|let|var|function|return|if|else|for|while|do|switch|case|break|continue|new|class|extends|import|export|from|default|async|await|try|catch|finally|throw|typeof|instanceof|in|of|this|null|undefined|true|false|interface|type|enum)\b"##, .keyword),
                (##"\b(?:console|document|window|process|require|module|JSON|Math|Promise|Array|Object|String|Number|Map|Set|fetch)\b"##, .builtin),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ]),
        "dockerfile": LangDef(
            primary: [
                (##"^\s*#[^\n]*"##, .comment),
                (##"\x22(?:\\.|[^\x22\\\n])*\x22"##, .string),
                (##"\x27[^\x27\n]*\x27"##, .string)
            ],
            secondary: [
                (##"^\s*(?:FROM|RUN|CMD|LABEL|EXPOSE|ENV|ADD|COPY|ENTRYPOINT|VOLUME|USER|WORKDIR|ARG|ONBUILD|STOPSIGNAL|HEALTHCHECK|SHELL|MAINTAINER)\b"##, .keyword),
                (##"\bAS\b"##, .keyword),
                (##"\$\{?[A-Za-z_]\w*\}?"##, .variable),
                (##"(?<=\s)--[A-Za-z][\w-]*"##, .flag),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ],
            ci: true),
        "toml": LangDef(
            primary: [
                (##"^\s*[#;][^\n]*|(?<=\s)#[^\n]*"##, .comment),
                (##"\x22(?:\\.|[^\x22\\\n])*\x22"##, .string),
                (##"\x27[^\x27\n]*\x27"##, .string)
            ],
            secondary: [
                (##"^\s*\[[^\]\n]+\]"##, .keyword),
                (##"^\s*[A-Za-z0-9_.-]+(?=\s*=)"##, .key),
                (##"\b(?:true|false)\b"##, .keyword),
                (##"\b\d+(?:\.\d+)?\b"##, .number)
            ])
    ]

    static let compiled: [String: CompiledLang] = defs.mapValues { CompiledLang($0) }
    private static var cache: [String: AttributedString] = [:]   // hanya dipakai dari main thread

    static func color(_ t: Tok) -> Color? {
        switch t {
        case .plain: return nil
        case .comment: return Color(nsColor: .systemGray)
        case .string: return Color(nsColor: .systemGreen)
        case .keyword: return Color(nsColor: .systemPink)
        case .number: return Color(nsColor: .systemOrange)
        case .builtin: return Color(nsColor: .systemTeal)
        case .variable: return Color(nsColor: .systemPurple)
        case .key: return Color(nsColor: .systemBlue)
        case .flag: return Color(nsColor: .systemYellow)
        }
    }

    static func highlight(_ code: String, lang: String) -> AttributedString {
        let l = canonical(lang)
        let k = l + "\u{1}" + code
        if let c = cache[k] { return c }
        let out = build(code, lang: l)
        if cache.count > 400 { cache.removeAll() }
        cache[k] = out
        return out
    }

    private static func build(_ code: String, lang: String) -> AttributedString {
        let ns = code as NSString
        let n = ns.length
        guard n > 0, n < 20000, let comp = compiled[lang] else { return AttributedString(code) }

        var kinds = [UInt8](repeating: 0, count: n)
        let full = NSRange(location: 0, length: n)

        if let p = comp.primary {
            p.enumerateMatches(in: code, options: [], range: full) { m, _, _ in
                guard let m = m else { return }
                for i in 0..<comp.primaryKinds.count {
                    let r = m.range(at: i + 1)
                    if r.location != NSNotFound {
                        for j in r.location..<(r.location + r.length) { kinds[j] = comp.primaryKinds[i].rawValue }
                        break
                    }
                }
            }
        }
        for (re, kind) in comp.secondary {
            re.enumerateMatches(in: code, options: [], range: full) { m, _, _ in
                guard let r = m?.range, r.length > 0 else { return }
                for j in r.location..<(r.location + r.length) where kinds[j] == 0 {
                    kinds[j] = kind.rawValue
                }
            }
        }

        var out = AttributedString()
        var start = 0
        while start < n {
            var end = start + 1
            while end < n && kinds[end] == kinds[start] { end += 1 }
            var seg = AttributedString(ns.substring(with: NSRange(location: start, length: end - start)))
            if let c = color(Tok(rawValue: kinds[start]) ?? .plain) { seg.foregroundColor = c }
            out.append(seg)
            start = end
        }
        return out
    }
}

// MARK: - Model

/// Hanya untuk membaca data lama bertipe "notes" (langkah demi langkah)
private struct LegacyStep: Decodable {
    var text: String?
    var code: String?
    var lang: String?
}

/// Satu command di dalam cheatsheet
struct Command: Identifiable, Codable, Equatable {
    var id = UUID()
    var label: String = ""     // opsional, mis. "Ekstrak" / "Buat"
    var code: String = ""
    var lang: String = "bash"

    enum CodingKeys: String, CodingKey { case id, label, code, lang }

    init(id: UUID = UUID(), label: String = "", code: String = "", lang: String = "bash") {
        self.id = id
        self.label = label
        self.code = code
        self.lang = lang
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.init(id: try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID(),
                  label: try c.decodeIfPresent(String.self, forKey: .label) ?? "",
                  code: try c.decodeIfPresent(String.self, forKey: .code) ?? "",
                  lang: try c.decodeIfPresent(String.self, forKey: .lang) ?? "bash")
    }
}

struct Note: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String = ""
    var categories: [String] = []
    var detail: String = ""
    var commands: [Command] = [Command()]
    var uses: Int = 0            // berapa kali disalin
    var lastUsed: Date? = nil    // terakhir disalin / dibuat, untuk urutan daftar
    var hints: [String: String] = [:]   // deskripsi per nama placeholder

    enum CodingKeys: String, CodingKey {
        case id, title, category, categories, detail, commands, command, lang, steps, uses, lastUsed, hints
    }

    /// Semua command digabung, untuk "Salin semua"
    var allCode: String {
        commands.map { $0.code }.filter { !$0.isEmpty }.joined(separator: "\n")
    }

    var searchText: String {
        var parts = [title, detail] + categories
        for c in commands { parts.append(c.label); parts.append(c.code) }
        return parts.joined(separator: " ").lowercased()
    }

    init(id: UUID = UUID(), title: String = "", categories: [String] = [],
         detail: String = "", commands: [Command] = [Command()],
         uses: Int = 0, lastUsed: Date? = nil, hints: [String: String] = [:]) {
        self.id = id
        self.title = title
        self.categories = categories
        self.detail = detail
        self.commands = commands
        self.uses = uses
        self.lastUsed = lastUsed
        self.hints = hints
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        let title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        // Kompatibel dengan file lama: field "category" tunggal menjadi array satu elemen
        var cats = try c.decodeIfPresent([String].self, forKey: .categories) ?? []
        if cats.isEmpty, let legacy = try c.decodeIfPresent(String.self, forKey: .category), !legacy.isEmpty {
            cats = [legacy]
        }
        let detail = try c.decodeIfPresent(String.self, forKey: .detail) ?? ""
        var cmds = (try? c.decodeIfPresent([Command].self, forKey: .commands)) ?? []
        if cmds.isEmpty {
            // Format lama: satu "command" + "lang"
            let code = try c.decodeIfPresent(String.self, forKey: .command) ?? ""
            let lang = try c.decodeIfPresent(String.self, forKey: .lang) ?? "bash"
            if !code.isEmpty { cmds = [Command(code: code, lang: lang)] }
        }
        if cmds.isEmpty, let steps = (try? c.decodeIfPresent([LegacyStep].self, forKey: .steps)) ?? nil {
            // Data lama bertipe "notes": tiap langkah menjadi satu command berlabel
            cmds = steps.filter { !($0.code ?? "").isEmpty }
                .map { Command(label: $0.text ?? "", code: $0.code ?? "", lang: $0.lang ?? "bash") }
        }
        if cmds.isEmpty { cmds = [Command()] }
        let uses = (try? c.decodeIfPresent(Int.self, forKey: .uses)) ?? nil
        let lastUsed = (try? c.decodeIfPresent(Date.self, forKey: .lastUsed)) ?? nil
        self.init(id: id, title: title, categories: cats, detail: detail, commands: cmds,
                  uses: uses ?? 0, lastUsed: lastUsed,
                  hints: ((try? c.decodeIfPresent([String: String].self, forKey: .hints)) ?? nil) ?? [:])
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(categories, forKey: .categories)
        try c.encode(detail, forKey: .detail)
        try c.encode(commands, forKey: .commands)
        if uses > 0 { try c.encode(uses, forKey: .uses) }
        try c.encodeIfPresent(lastUsed, forKey: .lastUsed)
        if !hints.isEmpty { try c.encode(hints, forKey: .hints) }
    }
}

// MARK: - Placeholder {{nama}} / {{nama:default}} / {{nama:a|b|c}}

struct Placeholder: Identifiable {
    let name: String
    let options: [String]          // saran dari command; yang pertama jadi default
    var def: String? { options.first }
    var id: String { name }
}

enum Placeholders {
    // Hanya nama tanpa spasi, supaya template Helm/Jinja seperti {{ .Values.x }} tidak ikut terdeteksi
    static let re = try! NSRegularExpression(pattern: #"\{\{([A-Za-z_][A-Za-z0-9_-]*)(?::([^{}\n]*))?\}\}"#)

    private static func matches(_ code: String) -> [NSTextCheckingResult] {
        guard code.contains("{{") else { return [] }
        return re.matches(in: code, range: NSRange(location: 0, length: (code as NSString).length))
    }

    static func splitOptions(_ raw: String) -> [String] {
        raw.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    /// Unik per nama, urut kemunculan. Saran dari kemunculan yang sama digabung.
    static func parse(_ code: String) -> [Placeholder] {
        let ns = code as NSString
        var order: [String] = []
        var opts: [String: [String]] = [:]
        for m in matches(code) {
            let name = ns.substring(with: m.range(at: 1))
            if opts[name] == nil { order.append(name); opts[name] = [] }
            let d = m.range(at: 2)
            if d.location != NSNotFound {
                for o in splitOptions(ns.substring(with: d)) where !opts[name]!.contains(o) {
                    opts[name]!.append(o)
                }
            }
        }
        return order.map { Placeholder(name: $0, options: opts[$0] ?? []) }
    }

    /// Teks literal tiap placeholder, untuk diwarnai
    static func literals(_ code: String) -> [String] {
        let ns = code as NSString
        return Array(Set(matches(code).map { ns.substring(with: $0.range) }))
    }

    /// Isian kosong memakai saran pertama (default) dari command
    static func fill(_ code: String, values: [String: String]) -> String {
        var defaults: [String: String] = [:]
        for p in parse(code) { defaults[p.name] = p.def ?? "" }
        let ns = NSMutableString(string: code)
        for m in matches(code).reversed() {
            let name = ns.substring(with: m.range(at: 1))
            let v = values[name] ?? ""
            ns.replaceCharacters(in: m.range, with: v.isEmpty ? (defaults[name] ?? "") : v)
        }
        return ns as String
    }
}

/// Saran global (dari Pengaturan) dan riwayat isian terakhir
enum PlaceholderMemory {
    static let recentKey = "placeholderRecent"
    static let maxRecent = 3

    /// Format per baris: "namespace = default, prod, dev". Baris diawali # diabaikan.
    static func global() -> [String: [String]] {
        var out: [String: [String]] = [:]
        for line in Settings.shared.placeholderRules.split(separator: "\n") {
            let l = line.trimmingCharacters(in: .whitespaces)
            guard !l.hasPrefix("#"), let eq = l.firstIndex(of: "=") else { continue }
            let name = l[..<eq].trimmingCharacters(in: .whitespaces)
            let vals = l[l.index(after: eq)...].split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            if !name.isEmpty && !vals.isEmpty { out[name, default: []] += vals }
        }
        return out
    }

    static func recent() -> [String: [String]] {
        UserDefaults.standard.dictionary(forKey: recentKey) as? [String: [String]] ?? [:]
    }

    static func remember(_ values: [String: String]) {
        var r = recent()
        for (name, v) in values {
            let v = v.trimmingCharacters(in: .whitespaces)
            guard !v.isEmpty else { continue }
            var list = r[name] ?? []
            list.removeAll { $0 == v }
            list.insert(v, at: 0)
            r[name] = Array(list.prefix(maxRecent))
        }
        UserDefaults.standard.set(r, forKey: recentKey)
    }

    static func clearRecent() { UserDefaults.standard.removeObject(forKey: recentKey) }
}

struct CatInfo: Identifiable {
    let name: String
    let count: Int
    var id: String { name }
}

// MARK: - Store

final class Store: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            rebuildDerived()
            if !suppress { scheduleSave() }
        }
    }
    @Published private(set) var categories: [CatInfo] = []
    @Published private(set) var version = 0
    @Published var isLoading = false

    private(set) var index: [(id: UUID, hay: String)] = []
    private var suppress = false
    private var lastSaved: [Note] = []
    private var saveWork: DispatchWorkItem?
    private let io = DispatchQueue(label: "cheatsheet.io", qos: .utility)

    static var localDir: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("CheatSheet", isDirectory: true)
    }

    static var dataFile: URL { localDir.appendingPathComponent("cheatsheet.json") }

    init() {
        load()
    }

    // MARK: turunan (kategori dan indeks pencarian)

    private func rebuildDerived() {
        var counts: [String: Int] = [:]
        var idx: [(id: UUID, hay: String)] = []
        idx.reserveCapacity(notes.count)
        for n in notes {
            for c in n.categories where !c.isEmpty { counts[c, default: 0] += 1 }
            idx.append((id: n.id, hay: n.searchText))
        }
        index = idx
        categories = counts.map { CatInfo(name: $0.key, count: $0.value) }
            .sorted { $0.count != $1.count ? $0.count > $1.count : $0.name < $1.name }
        version += 1
    }

    private func setNotes(_ n: [Note]) {
        suppress = true
        notes = n
        suppress = false
    }

    // MARK: encode / decode

    static func encode(_ notes: [Note]) throws -> Data {
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return try e.encode(notes)
    }

    static func decode(_ data: Data) -> [Note]? {
        try? JSONDecoder().decode([Note].self, from: data)
    }

    // MARK: muat (async, tidak memblokir UI)

    private func load() {
        isLoading = true
        io.async { [weak self] in
            var notes: [Note]?
            var fresh = false     // true: tulis ke disk sekarang
            if let data = try? Data(contentsOf: Store.dataFile) {
                notes = Store.decode(data)
                if notes == nil {
                    // File rusak: simpan salinan agar tidak tertimpa
                    let bad = Store.localDir.appendingPathComponent("cheatsheet-corrupt-\(Int(Date().timeIntervalSince1970)).json")
                    try? FileManager.default.copyItem(at: Store.dataFile, to: bad)
                }
            }
            if notes == nil {
                switch LegacyImport.load() {
                case .notes(let n): notes = n; fresh = true
                case .none: notes = Store.seed; fresh = true
                case .unreadable:
                    // Jangan tulis sebelum ada edit, supaya migrasi dicoba lagi saat launch berikutnya
                    notes = Store.seed
                }
            }
            let result = notes ?? []
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.setNotes(result)
                self.lastSaved = fresh ? [] : result
                if fresh { self.save() }
            }
        }
    }

    // MARK: simpan (debounce, background)

    private func scheduleSave() {
        guard !isLoading else { return }
        saveWork?.cancel()
        let w = DispatchWorkItem { [weak self] in
            self?.saveWork = nil
            self?.save()
        }
        saveWork = w
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: w)
    }

    func save() {
        guard !isLoading else { return }
        let snapshot = notes
        if snapshot == lastSaved && FileManager.default.fileExists(atPath: Store.dataFile.path) { return }
        io.async { [weak self] in
            do {
                try FileManager.default.createDirectory(at: Store.localDir, withIntermediateDirectories: true)
                try Store.encode(snapshot).write(to: Store.dataFile, options: .atomic)
                DispatchQueue.main.async { self?.lastSaved = snapshot }
            } catch {
                NSLog("CheatSheet save error: \(error)")
            }
        }
    }

    /// Dipanggil saat aplikasi keluar: pastikan perubahan terakhir sudah tertulis
    func flush() {
        if saveWork != nil {
            saveWork?.cancel()
            saveWork = nil
            save()
        }
        io.sync { }
    }

    func markUsed(_ id: UUID) {
        guard let i = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[i].uses += 1
        notes[i].lastUsed = Date()
    }

    // MARK: ekspor / impor

    func export(to url: URL) throws {
        try Store.encode(notes).write(to: url, options: .atomic)
    }

    /// Gabung: entri dengan ID sama diganti versi file, sisanya ditambahkan di atas.
    func importNotes(_ incoming: [Note], replace: Bool) {
        if replace {
            notes = incoming
            return
        }
        var merged = notes
        var added: [Note] = []
        for n in incoming {
            if let i = merged.firstIndex(where: { $0.id == n.id }) {
                merged[i] = n
            } else {
                added.append(n)
            }
        }
        notes = added + merged
    }

    // MARK: data contoh

    static func n(_ cat: String, _ title: String, _ cmd: String, _ detail: String = "", lang: String = "bash") -> Note {
        Note(title: title, categories: cat.isEmpty ? [] : [cat], detail: detail,
             commands: [Command(code: cmd, lang: lang)])
    }

    static let deployYAML = """
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: web
      labels:
        app: web
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: web
      template:
        metadata:
          labels:
            app: web
        spec:
          containers:
            - name: nginx
              image: nginx:1.25
              ports:
                - containerPort: 80
    """

    static let seed: [Note] = [
        n("files", "Cari file berdasarkan nama", "find . -type f -name \"*.log\"", "Tambahkan -mtime -1 untuk file yang berubah 1 hari terakhir"),
        n("files", "Ukuran folder urut terbesar", "du -sh * | sort -rh | head -20"),
        n("files", "Cari teks di banyak file", "grep -rniI \"pattern\" .", "-r rekursif, -n nomor baris, -i abaikan case, -I skip binary"),
        n("files", "Sinkron folder via SSH", "rsync -avzP src/ user@host:/dest/", "Trailing slash pada src penting"),
        Note(title: "tar.gz", categories: ["files"], detail: "Contoh satu cheatsheet dengan beberapa command",
             commands: [Command(label: "Ekstrak", code: "tar -xzvf {{file:file.tar.gz}} -C {{dir:/target/dir}}"),
                        Command(label: "Buat", code: "tar -czvf {{out:out.tar.gz}} {{folder}}/"),
                        Command(label: "Lihat isi", code: "tar -tzvf {{file:file.tar.gz}}")]),
        n("disk", "Pemakaian disk per filesystem", "df -hT"),
        n("disk", "Daftar block device", "lsblk -f"),
        n("disk", "Cek I/O disk", "iostat -xz 1", "Perhatikan %util dan await"),
        n("process", "Proses terbesar by memory", "ps aux --sort=-%mem | head -15"),
        n("process", "Proses terbesar by CPU", "ps aux --sort=-%cpu | head -15"),
        n("process", "Siapa yang pakai port", "ss -tulpn | grep :8080", "Alternatif: lsof -i :8080"),
        n("process", "Kill semua proses by nama", "pkill -f nama-proses"),
        n("network", "Cek koneksi TCP ke host:port", "nc -zv host 443"),
        n("network", "Test HTTP dengan kode dan waktu", "curl -sS -o /dev/null -w '%{http_code} %{time_total}s\\n' https://example.com"),
        n("network", "Lewat proxy", "curl -x http://proxy:3128 -I https://example.com"),
        n("network", "Cek DNS", "dig +short example.com", "Tambahkan @dns-server untuk pilih resolver"),
        n("network", "Lihat route ke tujuan", "traceroute -n host"),
        n("systemd", "Status service", "systemctl status nama.service"),
        n("systemd", "Log service live", "journalctl -u nama.service -f --since \"10 min ago\""),
        n("systemd", "Service yang gagal", "systemctl --failed"),
        n("ssh", "Port forward lokal", "ssh -L 8080:localhost:80 user@host"),
        n("ssh", "Copy key ke server", "ssh-copy-id user@host"),
        n("kubernetes", "Pod tidak Running di semua namespace", "kubectl get pods -A | grep -v Running"),
        n("kubernetes", "Event terbaru urut waktu", "kubectl get events -A --sort-by=.lastTimestamp | tail -30"),
        n("kubernetes", "Contoh Deployment YAML", deployYAML, "Contoh cheatsheet dengan highlight YAML", lang: "yaml"),
        n("python", "HTTP request dengan requests", "import requests\n\nr = requests.get(\"https://example.com\", timeout=5)\nprint(r.status_code)  # cek status", lang: "python")
    ]
}

// MARK: - Backup iCloud

/// Salinan read/write di iCloud Drive, terpisah dari data harian (yang tetap di Application Support).
/// Dipakai hanya untuk backup manual/otomatis dan restore; bukan lokasi baca/tulis sehari-hari.
enum BackupManager {
    static var dir: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Mobile Documents/com~apple~CloudDocs/CheatSheet/Backups", isDirectory: true)
    }

    static var isAvailable: Bool {
        FileManager.default.fileExists(atPath: FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Mobile Documents/com~apple~CloudDocs").path)
    }

    private static let df: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()

    private static let fileDf: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "ddMMyy-HHmm"
        return f
    }()

    struct Entry: Identifiable {
        var id: URL { url }
        let url: URL
        let date: Date
        var label: String { df.string(from: date) }
    }

    static func list() -> [Entry] {
        guard let items = try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: [.contentModificationDateKey]) else { return [] }
        return items
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> Entry? in
                guard let v = try? url.resourceValues(forKeys: [.contentModificationDateKey]),
                      let date = v.contentModificationDate else { return nil }
                return Entry(url: url, date: date)
            }
            .sorted { $0.date > $1.date }
    }

    /// Menulis backup baru dan menyisakan 5 terbaru. Melempar error kalau iCloud Drive tidak ada.
    @discardableResult
    static func backupNow(_ store: Store) throws -> Entry {
        guard isAvailable else {
            throw NSError(domain: "CheatSheet", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: t("backup_unavailable")])
        }
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("cheatsheet-\(fileDf.string(from: Date())).json")
        try Store.encode(store.notes).write(to: url, options: .atomic)
        let keep = 5
        let all = list()
        for stale in all.dropFirst(keep) {
            try? FileManager.default.removeItem(at: stale.url)
        }
        return Entry(url: url, date: Date())
    }

    static func notes(at url: URL) -> [Note]? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return Store.decode(data)
    }
}

// MARK: - App state

final class AppState: ObservableObject {
    @Published var pinned = false
    @Published var focusTick = 0
    @Published var busy = false          // true saat Pengaturan atau editor terbuka (cegah auto hide)
    var wantSettings = false
}

// MARK: - Helper hotkey

func modSymbols(_ f: NSEvent.ModifierFlags) -> String {
    var s = ""
    if f.contains(.control) { s += "⌃" }
    if f.contains(.option) { s += "⌥" }
    if f.contains(.shift) { s += "⇧" }
    if f.contains(.command) { s += "⌘" }
    return s
}

func keyName(_ e: NSEvent) -> String {
    let fKeys: [Int: String] = [
        kVK_F1: "F1", kVK_F2: "F2", kVK_F3: "F3", kVK_F4: "F4", kVK_F5: "F5", kVK_F6: "F6",
        kVK_F7: "F7", kVK_F8: "F8", kVK_F9: "F9", kVK_F10: "F10", kVK_F11: "F11", kVK_F12: "F12"
    ]
    let code = Int(e.keyCode)
    if let f = fKeys[code] { return f }
    switch code {
    case kVK_Space: return "Space"
    case kVK_Return: return "Return"
    case kVK_Tab: return "Tab"
    case kVK_Delete: return "Delete"
    case kVK_LeftArrow: return "←"
    case kVK_RightArrow: return "→"
    case kVK_UpArrow: return "↑"
    case kVK_DownArrow: return "↓"
    default: return (e.charactersIgnoringModifiers ?? "?").uppercased()
    }
}

final class HotKeyCenter {
    static let shared = HotKeyCenter()
    private var ref: EventHotKeyRef?
    private var installed = false
    var handler: (() -> Void)?

    @discardableResult
    func register(keyCode: Int, modifiers: Int) -> Bool {
        if !installed {
            var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                                     eventKind: UInt32(kEventHotKeyPressed))
            InstallEventHandler(GetApplicationEventTarget(), { _, _, _ in
                HotKeyCenter.shared.handler?()
                return noErr
            }, 1, &spec, nil, nil)
            installed = true
        }
        if let r = ref { UnregisterEventHotKey(r); ref = nil }
        let id = EventHotKeyID(signature: OSType(0x43485454), id: 1)
        let status = RegisterEventHotKey(UInt32(keyCode), UInt32(modifiers), id,
                                         GetApplicationEventTarget(), 0, &ref)
        return status == noErr
    }
}

// MARK: - Komponen kode

/// Memotong teks yang DITAMPILKAN di daftar agar render tetap ringan.
/// Teks yang disimpan dan disalin tetap utuh.
enum Preview {
    static let maxLines = 40
    static let maxChars = 3000

    static func clamp(_ code: String) -> String {
        guard !code.isEmpty else { return code }
        let lines = code.split(separator: "\n", omittingEmptySubsequences: false)
        if lines.count > maxLines {
            var head = lines.prefix(maxLines).joined(separator: "\n")
            if head.count > maxChars { head = String(head.prefix(maxChars)) }
            let msg = t("preview_more_lines").replacingOccurrences(of: "%d", with: "\(lines.count - maxLines)")
            return head + "\n… (\(msg))"
        }
        if code.count > maxChars {
            return String(code.prefix(maxChars)) + "\n… (\(t("preview_truncated")))"
        }
        return code
    }
}

enum Mark {
    static let hit = Color(nsColor: .findHighlightColor)

    /// Sorot kata pencarian (tidak peka huruf besar/kecil)
    static func search(_ s: inout AttributedString, _ words: [String]) {
        for w in words where !w.isEmpty {
            var start = s.startIndex
            while start < s.endIndex, let r = s[start...].range(of: w, options: .caseInsensitive) {
                s[r].backgroundColor = hit
                s[r].foregroundColor = .black
                start = r.upperBound
            }
        }
    }

    static func placeholders(_ s: inout AttributedString, code: String) {
        for lit in Placeholders.literals(code) {
            var start = s.startIndex
            while start < s.endIndex, let r = s[start...].range(of: lit) {
                s[r].foregroundColor = .accentColor
                s[r].backgroundColor = Color.accentColor.opacity(0.15)
                start = r.upperBound
            }
        }
    }

    static func text(_ plain: String, _ words: [String]) -> AttributedString {
        var a = AttributedString(plain)
        search(&a, words)
        return a
    }
}

extension Color {
    /// Latar blok kode yang menyesuaikan mode terang/gelap
    static var codeBG: Color { Color(nsColor: .textBackgroundColor).opacity(0.6) }
}

extension View {
    func codeBox() -> some View {
        padding(8)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.codeBG))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.18)))
    }
}

struct LangBadge: View {
    let lang: String
    var body: some View {
        Text(Highlighter.canonical(lang))
            .font(.system(size: 9, weight: .semibold, design: .monospaced))
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(Capsule().fill(Color.secondary.opacity(0.18)))
            .foregroundStyle(.secondary)
    }
}

struct CodeText: View {
    let code: String
    let lang: String
    var maxLines: Int? = nil
    var marks: [String] = []

    var body: some View {
        var a = Highlighter.highlight(code, lang: lang)
        Mark.placeholders(&a, code: code)
        Mark.search(&a, marks)
        return Text(a)
            .font(.system(size: 12, design: .monospaced))
            .lineLimit(maxLines)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Blok kode dengan badge bahasa di pojok kanan atas
/// Kalau kodenya dipotong, muncul tombol "Lihat semua" (hanya bila maxLines nil).
struct CodeBlock: View {
    let code: String
    let lang: String
    var maxLines: Int? = nil
    var marks: [String] = []

    @State private var expanded = false

    var body: some View {
        let clamped = Preview.clamp(code)
        let truncated = maxLines == nil && clamped != code
        VStack(alignment: .leading, spacing: 4) {
            CodeText(code: expanded ? code : clamped, lang: lang, maxLines: maxLines, marks: marks)
                .padding(.trailing, 44)
                .codeBox()
                .overlay(alignment: .topTrailing) { LangBadge(lang: lang).padding(6) }
            if truncated {
                Button {
                    expanded.toggle()
                } label: {
                    Label(expanded ? t("view_less")
                                   : t("view_all", code.split(separator: "\n", omittingEmptySubsequences: false).count),
                          systemImage: expanded ? "chevron.up" : "chevron.down")
                }
                .buttonStyle(.plain)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.accentColor)
            }
        }
    }
}

/// Editor teks monospace tanpa smart quotes, smart dash, atau koreksi otomatis
struct CodeEditor: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeNSView(context: Context) -> NSScrollView {
        let scroll = NSTextView.scrollableTextView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        if let tv = scroll.documentView as? NSTextView {
            tv.delegate = context.coordinator
            tv.isRichText = false
            tv.allowsUndo = true
            tv.isAutomaticQuoteSubstitutionEnabled = false
            tv.isAutomaticDashSubstitutionEnabled = false
            tv.isAutomaticTextReplacementEnabled = false
            tv.isAutomaticSpellingCorrectionEnabled = false
            tv.isContinuousSpellCheckingEnabled = false
            tv.isAutomaticLinkDetectionEnabled = false
            tv.isAutomaticDataDetectionEnabled = false
            tv.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
            tv.textColor = .labelColor
            tv.drawsBackground = false
            tv.textContainerInset = NSSize(width: 4, height: 4)
            tv.string = text
        }
        return scroll
    }

    func updateNSView(_ scroll: NSScrollView, context: Context) {
        guard let tv = scroll.documentView as? NSTextView else { return }
        if tv.string != text { tv.string = text }
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CodeEditor
        init(_ p: CodeEditor) { parent = p }
        func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            parent.text = tv.string
        }
    }
}

/// Layout sederhana yang membungkus chip ke baris berikutnya
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: width == .infinity ? x : width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX; y += rowHeight + spacing; rowHeight = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

/// Input label: ketik lalu Enter atau koma untuk menambah, klik x untuk menghapus
struct CategoryTagField: View {
    @Binding var categories: [String]
    @State private var input = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !categories.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(categories, id: \.self) { c in
                        HStack(spacing: 4) {
                            Text(c).font(.system(size: 12))
                            Button { categories.removeAll { $0 == c } } label: {
                                Image(systemName: "xmark.circle.fill").font(.system(size: 11))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color.accentColor.opacity(0.2)))
                    }
                }
            }
            TextField(t("f_category"), text: $input)
                .textFieldStyle(.roundedBorder)
                .onChange(of: input) { _, new in
                    if new.contains(",") { commit(new) }
                }
                .onSubmit { commit(input) }
        }
    }

    func commit(_ raw: String) {
        let parts = raw.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        for p in parts where !p.isEmpty && !categories.contains(p) {
            categories.append(p)
        }
        input = ""
    }
}

// MARK: - Views

/// Query pencarian: token "#label" memfilter kategori, sisanya dicari di teks
struct SearchQuery {
    var tags: [String] = []      // huruf kecil, tanpa "#"
    var words: [String] = []     // huruf kecil
    var rawWords: [String] = []  // huruf asli, untuk judul cheatsheet baru

    init(_ q: String) {
        for tok in q.split(separator: " ").map(String.init) {
            if tok.hasPrefix("#") {
                let tag = String(tok.dropFirst()).lowercased()
                if !tag.isEmpty { tags.append(tag) }
            } else {
                words.append(tok.lowercased())
                rawWords.append(tok)
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var store: Store
    @ObservedObject var state: AppState
    @ObservedObject var settings = Settings.shared
    var onClose: () -> Void

    @State private var query = ""
    @State private var selected = 0
    @State private var results: [Note] = []
    @State private var totalMatches = 0
    @State private var editing: Note?
    @State private var isNew = false
    @State private var filling: FillRequest?
    @State private var activeCmd = 0      // command aktif di cheatsheet terpilih
    @State private var pendingDelete: Note?
    @State private var hovered: UUID?
    @State private var toast: String?
    @State private var showSettings = false
    @State private var selectedCategory: String?
    @State private var visibleCategories = 10
    @FocusState private var searchFocused: Bool

    static let maxShown = 300
    static let wideWidth: CGFloat = 700

    var parsed: SearchQuery { SearchQuery(query) }
    var selectedNote: Note? { results.indices.contains(selected) ? results[selected] : nil }

    var body: some View {
        ZStack {
            if let note = editing {
                EditorView(note: note, isNew: isNew,
                           onSave: { saved in
                               if isNew {
                                   var n = saved
                                   n.lastUsed = Date()   // cheatsheet baru muncul di atas
                                   store.notes.insert(n, at: 0)
                               } else if let i = store.notes.firstIndex(where: { $0.id == saved.id }) {
                                   store.notes[i] = saved
                               }
                               editing = nil
                               searchFocused = true
                           },
                           onCancel: { editing = nil; searchFocused = true })
            } else if let req = filling {
                FillView(req: req,
                         onCopy: { text in
                             filling = nil
                             finishCopy(text, id: req.noteID)
                             searchFocused = true
                         },
                         onCancel: { filling = nil; searchFocused = true })
            } else if showSettings {
                SettingsView(store: store, settings: settings,
                             onBack: { showSettings = false; searchFocused = true })
            } else {
                mainView
            }
        }
        .frame(minWidth: 560, minHeight: 420)
        .background(.regularMaterial)
        .onChange(of: state.focusTick) { _, _ in
            query = ""
            selected = 0
            editing = nil
            filling = nil
            pendingDelete = nil
            showSettings = state.wantSettings
            state.wantSettings = false
            searchFocused = true
            recompute(keepSelection: false)
        }
        .onChange(of: query) { _, _ in selected = 0; pendingDelete = nil; recompute(keepSelection: false) }
        .onChange(of: selectedCategory) { _, _ in selected = 0; recompute(keepSelection: false) }
        .onChange(of: store.version) { _, _ in recompute() }
        .onChange(of: showSettings) { _, _ in updateBusy() }
        .onChange(of: editing) { _, _ in updateBusy() }
        .onChange(of: filling) { _, _ in updateBusy() }
        .onChange(of: selected) { _, _ in activeCmd = 0 }
        .onAppear { searchFocused = true; recompute() }
    }

    func updateBusy() { state.busy = showSettings || editing != nil || filling != nil }

    // MARK: pencarian dan urutan

    func recompute(keepSelection: Bool = true) {
        let prev = keepSelection ? selectedNote?.id : nil
        let q = parsed
        let notes = store.notes
        let idx = store.index
        let useIndex = idx.count == notes.count

        var hits: [(note: Note, order: Int, titleHit: Bool)] = []
        for i in 0..<notes.count {
            let n = notes[i]
            if let c = selectedCategory, !n.categories.contains(c) { continue }
            if !q.tags.isEmpty {
                let cats = n.categories.map { $0.lowercased() }
                if !q.tags.allSatisfy({ tag in cats.contains { $0.hasPrefix(tag) } }) { continue }
            }
            var titleHit = false
            if !q.words.isEmpty {
                let h = useIndex ? idx[i].hay : n.searchText
                if !q.words.allSatisfy({ h.contains($0) }) { continue }
                let tl = n.title.lowercased()
                titleHit = q.words.allSatisfy { tl.contains($0) }
            }
            hits.append((n, i, titleHit))
        }
        // Judul yang cocok di atas, lalu yang terakhir dipakai, lalu urutan asli
        hits.sort { a, b in
            if a.titleHit != b.titleHit { return a.titleHit }
            let da = a.note.lastUsed ?? .distantPast, db = b.note.lastUsed ?? .distantPast
            if da != db { return da > db }
            return a.order < b.order
        }
        results = hits.prefix(Self.maxShown).map { $0.note }
        totalMatches = hits.count
        if let p = prev, let i = results.firstIndex(where: { $0.id == p }) {
            selected = i
        } else if selected >= results.count {
            selected = max(0, results.count - 1)
        }
    }

    // MARK: layout utama

    var mainView: some View {
        VStack(spacing: 0) {
            searchBar
            categoryBar
            Divider()
            GeometryReader { geo in
                if geo.size.width >= Self.wideWidth {
                    HStack(spacing: 0) {
                        list(wide: true)
                            .frame(width: max(270, geo.size.width * 0.4))
                        Divider()
                        detailPane
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    list(wide: false)
                }
            }
            Divider()
            footer
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {
                if let d = pendingDelete { deleteBar(d) }
                if let msg = toast {
                    Text(msg)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Capsule().fill(Color.accentColor))
                        .foregroundStyle(.white)
                        .transition(.opacity)
                }
            }
            .padding(.bottom, 40)
        }
    }

    var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField(t("search"), text: $query)
                .textFieldStyle(.plain)
                .font(.system(size: 18))
                .focused($searchFocused)
                .onSubmit {
                    if let d = pendingDelete { delete(d) } else if let n = selectedNote { copyNote(n) }
                }
                .onKeyPress(.downArrow) { move(1); return .handled }
                .onKeyPress(.upArrow) { move(-1); return .handled }
                .onKeyPress(keys: [.tab]) { press in
                    guard let n = selectedNote, n.commands.count > 1 else { return .ignored }
                    let d = press.modifiers.contains(.shift) ? -1 : 1
                    activeCmd = (activeCmd + d + n.commands.count) % n.commands.count
                    return .handled
                }
                .onKeyPress(.escape) {
                    if pendingDelete != nil { pendingDelete = nil }
                    else if !query.isEmpty { query = "" }
                    else { onClose() }
                    return .handled
                }
            Button { state.pinned.toggle() } label: {
                Image(systemName: state.pinned ? "pin.fill" : "pin")
                    .foregroundStyle(state.pinned ? Color.accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .help(state.pinned ? t("pin_on") : t("pin_off"))
            Button { newNote() } label: { Image(systemName: "plus") }
                .buttonStyle(.plain)
                .keyboardShortcut("n", modifiers: .command)
                .disabled(store.isLoading)
                .help(t("add_help"))
            Button { showSettings = true } label: { Image(systemName: "gearshape") }
                .buttonStyle(.plain)
                .keyboardShortcut(",", modifiers: .command)
                .help(t("settings"))
        }
        .padding(14)
        .background {
            // Shortcut tanpa tombol terlihat
            Group {
                Button("") { if let n = selectedNote { edit(n) } }
                    .keyboardShortcut("e", modifiers: .command)
                Button("") { if let n = selectedNote { pendingDelete = n } }
                    .keyboardShortcut(.delete, modifiers: .command)
                ForEach(1...9, id: \.self) { i in
                    Button("") { if let n = selectedNote, n.commands.count >= i { copyNote(n, index: i - 1) } }
                        .keyboardShortcut(KeyEquivalent(Character("\(i)")), modifiers: .command)
                }
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            .disabled(selectedNote == nil)
        }
    }

    var footer: some View {
        HStack {
            Text("↑↓ \(t("select"))    \((selectedNote?.commands.count ?? 0) > 1 ? "⇥ \(t("switch_cmd"))    " : "")⏎ \(t("copy"))    ⌘E \(t("edit_short"))    ⌘N \(t("add"))")
                .lineLimit(1)
            Spacer()
            if totalMatches > results.count {
                Text("\(t("showing")) \(results.count)/\(totalMatches)")
            } else {
                Text("\(totalMatches) \(t("notes_count"))")
            }
        }
        .font(.system(size: 11))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .help(t("hotkey_tip", settings.hotkeyLabel))
    }

    func deleteBar(_ d: Note) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "trash").foregroundStyle(.red)
            Text(t("delete_q", d.title)).font(.system(size: 12, weight: .medium)).lineLimit(1)
            Spacer()
            Button(t("cancel")) { pendingDelete = nil }
            Button(t("delete"), role: .destructive) { delete(d) }
                .buttonStyle(.borderedProminent)
                .tint(.red)
        }
        .controlSize(.small)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary.opacity(0.25)))
        .shadow(radius: 8, y: 2)
        .padding(.horizontal, 14)
        .frame(maxWidth: 520)
    }

    // MARK: daftar

    func list(wide: Bool) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(Array(results.enumerated()), id: \.element.id) { idx, note in
                        row(note, isSelected: idx == selected, wide: wide)
                            .id(note.id)
                            .onTapGesture(count: 2) { selected = idx; copyNote(note) }
                            .simultaneousGesture(TapGesture().onEnded { selected = idx; pendingDelete = nil })
                            .contextMenu {
                                Button(t("copy_btn")) { copyNote(note) }
                                Button(t("edit")) { edit(note) }
                                Divider()
                                Button(t("delete"), role: .destructive) { pendingDelete = note }
                            }
                    }
                    if store.isLoading {
                        HStack(spacing: 6) {
                            ProgressView().controlSize(.small)
                            Text(t("loading")).foregroundStyle(.secondary)
                        }
                        .padding(30)
                    } else if results.isEmpty {
                        emptyState
                    }
                }
                .padding(8)
            }
            .onChange(of: selected) { _, new in
                if results.indices.contains(new) { proxy.scrollTo(results[new].id) }
            }
        }
    }

    var emptyState: some View {
        let q = query.trimmingCharacters(in: .whitespaces)
        return VStack(spacing: 10) {
            Image(systemName: q.isEmpty ? "tray" : "magnifyingglass")
                .font(.system(size: 28))
                .foregroundStyle(.tertiary)
            Text(q.isEmpty ? (store.notes.isEmpty ? t("empty_title") : t("no_results")) : t("no_results_for", q))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                newNote(prefill: q.isEmpty ? nil : parsed)
            } label: {
                Label(q.isEmpty || parsed.rawWords.isEmpty
                      ? t("ed_new_cheat")
                      : t("create_from", parsed.rawWords.joined(separator: " ")),
                      systemImage: "plus")
            }
            .controlSize(.small)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
    }

    func row(_ note: Note, isSelected: Bool, wide: Bool) -> some View {
        let words = parsed.words
        let showActions = hovered == note.id || isSelected
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(Mark.text(note.title, words))
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                Spacer(minLength: 4)
                if showActions {
                    iconButton("doc.on.doc", t("copy_btn")) { copyNote(note) }
                    iconButton("pencil", t("edit")) { edit(note) }
                } else {
                    if note.commands.count > 1 {
                        Text(t("cmd_n", note.commands.count))
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    if !wide { categoryChips(note.categories, limit: 2) }
                }
            }
            if !wide && isSelected {
                detailBody(note, compact: true).padding(.top, 4)
            } else {
                Text(Mark.text(firstLine(note.commands.first?.code ?? ""), words))
                    .font(.system(size: 11.5, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor.opacity(0.22)
                      : hovered == note.id ? Color.secondary.opacity(0.08) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { inside in
            if inside { hovered = note.id } else if hovered == note.id { hovered = nil }
        }
    }

    func iconButton(_ symbol: String, _ help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11))
                .frame(width: 20, height: 18)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .help(help)
    }

    func firstLine(_ s: String) -> String {
        s.split(separator: "\n").first { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.map(String.init) ?? ""
    }

    // MARK: detail

    var detailPane: some View {
        Group {
            if let n = selectedNote {
                ScrollView {
                    detailBody(n, compact: false)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "text.cursor").font(.system(size: 24)).foregroundStyle(.tertiary)
                    Text(t("empty_select")).font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
        }
    }

    func detailBody(_ note: Note, compact: Bool) -> some View {
        let words = parsed.words
        let fields = Placeholders.parse(note.commands.map { $0.code }.joined(separator: "\n"))
        let multi = note.commands.count > 1
        let isCurrent = note.id == selectedNote?.id
        return VStack(alignment: .leading, spacing: 10) {
            if !compact {
                Text(Mark.text(note.title, words))
                    .font(.system(size: 16, weight: .semibold))
                    .textSelection(.enabled)
                if !note.categories.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(note.categories, id: \.self) { c in
                            Button { selectedCategory = (selectedCategory == c) ? nil : c } label: {
                                Text(c)
                                    .font(.system(size: 11, weight: .medium))
                                    .padding(.horizontal, 8).padding(.vertical, 3)
                                    .background(Capsule().fill(selectedCategory == c
                                                               ? Color.accentColor.opacity(0.35)
                                                               : Color.secondary.opacity(0.18)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            ForEach(Array(note.commands.enumerated()), id: \.element.id) { i, cmd in
                commandBlock(note, index: i, cmd: cmd, words: words,
                             active: multi && isCurrent && i == activeCmd, multi: multi)
            }
            if !note.detail.isEmpty {
                Text(Mark.text(note.detail, words))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if !fields.isEmpty || note.uses > 0 {
                HStack(spacing: 10) {
                    if !fields.isEmpty {
                        Label("\(t("placeholders")): \(fields.map { $0.name }.joined(separator: ", "))",
                              systemImage: "curlybraces")
                    }
                    if note.uses > 0 {
                        Label(t("used_n", note.uses), systemImage: "clock.arrow.circlepath")
                    }
                }
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                Button { copyNote(note) } label: { Text("\(t("copy_btn"))  ⏎") }
                    .buttonStyle(.borderedProminent)
                if multi {
                    Button { copyAll(note) } label: { Text(t("copy_all")) }
                }
                Button { edit(note) } label: { Text("\(t("edit"))  ⌘E") }
                Button(role: .destructive) { pendingDelete = note } label: { Text("\(t("delete"))  ⌘⌫") }
            }
            .controlSize(.small)
        }
    }

    func commandBlock(_ note: Note, index i: Int, cmd: Command, words: [String],
                      active: Bool, multi: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if multi || !cmd.label.isEmpty {
                HStack(spacing: 6) {
                    if multi {
                        Text("⌘\(i + 1)")
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundStyle(active ? Color.accentColor : .secondary)
                    }
                    if !cmd.label.isEmpty {
                        Text(Mark.text(cmd.label, words)).font(.system(size: 12, weight: .medium))
                    }
                    Spacer()
                    iconButton("doc.on.doc", t("copy_btn")) { copyNote(note, index: i) }
                }
            }
            CodeBlock(code: cmd.code, lang: cmd.lang, marks: words)
                .overlay(RoundedRectangle(cornerRadius: 6)
                    .stroke(active ? Color.accentColor : Color.clear, lineWidth: 1.5))
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) { copyNote(note, index: i) }
        .simultaneousGesture(TapGesture().onEnded { if note.id == selectedNote?.id { activeCmd = i } })
    }

    // MARK: kategori

    var categoryBar: some View {
        let cats = store.categories
        return HStack(spacing: 8) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        chip(t("all"), count: store.notes.count, active: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(cats.prefix(visibleCategories)) { c in
                            chip(c.name, count: c.count, active: selectedCategory == c.name) {
                                selectedCategory = (selectedCategory == c.name) ? nil : c.name
                            }
                            .id(c.name)
                        }
                    }
                    .padding(.leading, 14)
                }
                .onChange(of: visibleCategories) { old, new in
                    if new > old, cats.indices.contains(old) {
                        withAnimation { proxy.scrollTo(cats[old].name, anchor: .leading) }
                    }
                }
            }
            if cats.count > visibleCategories {
                Button("\(t("more")) +\(min(10, cats.count - visibleCategories))") {
                    visibleCategories += 10
                }
                .buttonStyle(.plain)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.accentColor)
            } else if cats.count > 10 {
                Button(t("less")) { visibleCategories = 10 }
                    .buttonStyle(.plain)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.bottom, 8)
        .padding(.trailing, 14)
    }

    func chip(_ text: String, count: Int, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(text)
                Text("\(count)").foregroundStyle(.secondary)
            }
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(Capsule().fill(active ? Color.accentColor.opacity(0.35) : Color.secondary.opacity(0.18)))
            .overlay(Capsule().stroke(active ? Color.accentColor : Color.clear, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    func categoryChips(_ cats: [String], limit: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(cats.prefix(limit), id: \.self) { c in
                Text(c)
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Capsule().fill(Color.secondary.opacity(0.2)))
            }
            if cats.count > limit {
                Text("+\(cats.count - limit)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: aksi

    func move(_ delta: Int) {
        guard !results.isEmpty else { return }
        pendingDelete = nil
        selected = max(0, min(results.count - 1, selected + delta))
    }

    func newNote(prefill: SearchQuery? = nil) {
        guard !store.isLoading else { return }
        var n = Note()
        if let p = prefill {
            n.title = p.rawWords.joined(separator: " ")
            n.categories = p.tags.map { tag in
                store.categories.first { $0.name.lowercased().hasPrefix(tag) }?.name ?? tag
            }
        } else if let c = selectedCategory {
            n.categories = [c]
        }
        isNew = true
        editing = n
    }

    func edit(_ note: Note) {
        pendingDelete = nil
        isNew = false
        editing = note
    }

    func delete(_ note: Note) {
        store.notes.removeAll { $0.id == note.id }
        pendingDelete = nil
    }

    /// Salin satu command (default: command aktif). Kalau ada placeholder, minta isian dulu.
    func copyNote(_ note: Note, index: Int? = nil) {
        let i = index ?? (note.id == selectedNote?.id ? activeCmd : 0)
        guard note.commands.indices.contains(i) else { return }
        let cmd = note.commands[i]
        copyCode(note, code: cmd.code, lang: cmd.lang)
    }

    func copyAll(_ note: Note) {
        copyCode(note, code: note.allCode, lang: note.commands.first?.lang ?? "bash")
    }

    func copyCode(_ note: Note, code: String, lang: String) {
        pendingDelete = nil
        if Placeholders.parse(code).isEmpty {
            finishCopy(code, id: note.id)
        } else {
            filling = FillRequest(noteID: note.id, title: note.title, code: code, lang: lang, hints: note.hints)
        }
    }

    func finishCopy(_ text: String, id: UUID) {
        guard !text.isEmpty else { return }
        store.markUsed(id)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        if state.pinned {
            withAnimation { toast = t("copied") }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { toast = nil }
            }
        } else {
            onClose()
        }
    }
}

/// Teks yang menunggu diisi placeholder-nya sebelum disalin
struct FillRequest: Equatable {
    let noteID: UUID
    let title: String
    let code: String
    let lang: String
    var hints: [String: String] = [:]
}

/// Satu saran di form isian
struct Suggestion: Hashable {
    let value: String
    let recent: Bool
}

/// Form isian placeholder sebelum menyalin
struct FillView: View {
    let req: FillRequest
    var onCopy: (String) -> Void
    var onCancel: () -> Void

    @State private var values: [String: String] = [:]
    @State private var showPreview = true
    @FocusState private var focus: String?

    private let global = PlaceholderMemory.global()
    private let recent = PlaceholderMemory.recent()

    var fields: [Placeholder] { Placeholders.parse(req.code) }
    var result: String { Placeholders.fill(req.code, values: values) }

    /// Saran dari command, lalu saran global, lalu riwayat terakhir (tanpa duplikat)
    func suggestions(_ f: Placeholder) -> [Suggestion] {
        var seen = Set<String>()
        var out: [Suggestion] = []
        for v in f.options + (global[f.name] ?? []) where seen.insert(v).inserted {
            out.append(Suggestion(value: v, recent: false))
        }
        for v in recent[f.name] ?? [] where seen.insert(v).inserted {
            out.append(Suggestion(value: v, recent: true))
        }
        return out
    }

    func matches(_ s: Suggestion, typed: String) -> Bool {
        typed.isEmpty || s.value.localizedCaseInsensitiveContains(typed)
    }

    func binding(_ name: String) -> Binding<String> {
        Binding(get: { values[name] ?? "" }, set: { values[name] = $0 })
    }

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                if geo.size.width >= 700 {
                    HStack(alignment: .top, spacing: 0) {
                        ScrollView { form.padding(16) }
                            .frame(width: max(320, geo.size.width * 0.45))
                        Divider()
                        ScrollView { previewPane.padding(16) }
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            form
                            Button(showPreview ? t("hide_preview") : t("show_preview")) {
                                showPreview.toggle()
                            }
                            .buttonStyle(.plain)
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                            if showPreview { CodeBlock(code: result, lang: req.lang) }
                        }
                        .padding(16)
                    }
                }
            }
            Divider()
            HStack {
                Text(t("fill_hint")).font(.system(size: 11)).foregroundStyle(.secondary).lineLimit(1)
                Spacer()
                Button(t("cancel"), action: onCancel).keyboardShortcut(.cancelAction)
                Button(t("copy_raw")) { onCopy(req.code) }
                Button(t("copy_btn")) { copy() }
                    .keyboardShortcut(.return, modifiers: .command)
                    .buttonStyle(.borderedProminent)
            }
            .padding(12)
        }
        .background {
            // ⌥1–9: pilih saran ke-N untuk isian yang sedang aktif
            Group {
                ForEach(1...9, id: \.self) { i in
                    Button("") { pick(index: i - 1) }
                        .keyboardShortcut(KeyEquivalent(Character("\(i)")), modifiers: .option)
                }
            }
            .frame(width: 0, height: 0)
            .opacity(0)
        }
        .onAppear { focus = fields.first?.name }
    }

    var form: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(t("fill_title")).font(.headline)
            Text(req.title).font(.system(size: 12)).foregroundStyle(.secondary)
            ForEach(fields) { f in field(f) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var previewPane: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(t("ed_preview")).font(.caption).foregroundStyle(.secondary)
            CodeBlock(code: result, lang: req.lang)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func field(_ f: Placeholder) -> some View {
        let sugg = suggestions(f)
        let typed = values[f.name] ?? ""
        let active = focus == f.name
        return VStack(alignment: .leading, spacing: 5) {
            Text(f.name).font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(active ? Color.accentColor : .secondary)
            if let h = req.hints[f.name], !h.isEmpty {
                Text(h)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            TextField(f.def ?? f.name, text: binding(f.name))
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))
                .focused($focus, equals: f.name)
                .onSubmit { next(after: f) }
                .onKeyPress(keys: [.tab]) { press in
                    // ⇥ melengkapi dengan saran pertama yang cocok; kalau tidak ada, pindah isian seperti biasa
                    guard !press.modifiers.contains(.shift), !typed.isEmpty,
                          let m = sugg.first(where: { matches($0, typed: typed) }), m.value != typed
                    else { return .ignored }
                    values[f.name] = m.value
                    return .handled
                }
            if !sugg.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(Array(sugg.enumerated()), id: \.element) { i, s in
                        chip(s, number: active && i < 9 ? i + 1 : nil,
                             selected: typed == s.value,
                             dim: !matches(s, typed: typed)) {
                            values[f.name] = s.value
                            focus = f.name
                        }
                    }
                }
            }
        }
    }

    func chip(_ s: Suggestion, number: Int?, selected: Bool, dim: Bool,
              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let n = number {
                    Text("⌥\(n)").font(.system(size: 9, weight: .semibold)).foregroundStyle(.secondary)
                }
                if s.recent {
                    Image(systemName: "clock.arrow.circlepath").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                Text(s.value).font(.system(size: 11, design: .monospaced))
            }
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(selected ? Color.accentColor.opacity(0.35) : Color.secondary.opacity(0.16)))
            .overlay(Capsule().stroke(selected ? Color.accentColor : Color.clear, lineWidth: 1))
            .opacity(dim ? 0.35 : 1)
        }
        .buttonStyle(.plain)
        .help(s.recent ? t("recent") : "")
    }

    func pick(index: Int) {
        guard let name = focus, let f = fields.first(where: { $0.name == name }) else { return }
        let sugg = suggestions(f)
        guard sugg.indices.contains(index) else { return }
        values[name] = sugg[index].value
    }

    func copy() {
        PlaceholderMemory.remember(values)
        onCopy(result)
    }

    /// Enter pindah ke isian berikutnya; di isian terakhir langsung menyalin
    func next(after f: Placeholder) {
        let fs = fields
        if let i = fs.firstIndex(where: { $0.name == f.name }), i + 1 < fs.count {
            focus = fs[i + 1].name
        } else {
            copy()
        }
    }
}

struct EditorView: View {
    @State var note: Note
    let isNew: Bool
    var onSave: (Note) -> Void
    var onCancel: () -> Void

    @State private var detailExpanded = false
    @State private var expandedCmds: Set<UUID> = []
    @State private var placeholdersOpen = true

    var valid: Bool {
        !note.title.trimmingCharacters(in: .whitespaces).isEmpty
            && note.commands.contains { !$0.code.isEmpty }
    }

    /// Tombol perluas / perkecil
    func expandButton(_ on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: on ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 11))
        }
        .buttonStyle(.borderless)
        .help(on ? t("collapse") : t("expand"))
    }

    /// Tinggi editor kode: normal, atau menyesuaikan isi saat diperluas
    func editorHeight(_ code: String, expanded: Bool, base: CGFloat) -> CGFloat {
        guard expanded else { return base }
        let lines = code.split(separator: "\n", omittingEmptySubsequences: false).count
        return min(max(CGFloat(lines) * 15 + 20, base * 2), 1400)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(isNew ? t("ed_new_cheat") : t("edit")).font(.headline)
                    TextField(t("f_title"), text: $note.title).textFieldStyle(.roundedBorder)
                    CategoryTagField(categories: $note.categories)
                    HStack {
                        Text(t("f_detail")).font(.caption).foregroundStyle(.secondary)
                        Spacer()
                        expandButton(detailExpanded) { detailExpanded.toggle() }
                    }
                    TextField(t("f_detail"), text: $note.detail, axis: .vertical)
                        .lineLimit(detailExpanded ? 8...40 : 1...3)
                        .textFieldStyle(.roundedBorder)
                    HStack {
                        Text(t("f_command")).font(.subheadline.bold())
                        Spacer()
                        Button { note.commands.append(Command(lang: note.commands.last?.lang ?? "bash")) } label: {
                            Label(t("ed_add_cmd"), systemImage: "plus")
                        }
                    }
                    .padding(.top, 4)
                    Text(t("placeholder_hint")).font(.system(size: 11)).foregroundStyle(.secondary)
                    ForEach($note.commands) { $cmd in
                        commandEditor($cmd)
                    }
                    placeholderDocs
                }
                .padding(16)
            }
            Divider()
            HStack {
                Spacer()
                Button(t("cancel"), action: onCancel).keyboardShortcut(.cancelAction)
                Button(t("save")) { onSave(cleaned()) }
                    .keyboardShortcut(.return, modifiers: .command)
                    .disabled(!valid)
            }
            .padding(12)
        }
    }

    /// Nama placeholder dari semua command, urut kemunculan
    var placeholderNames: [String] {
        Placeholders.parse(note.commands.map { $0.code }.joined(separator: "\n")).map { $0.name }
    }

    @ViewBuilder var placeholderDocs: some View {
        let names = placeholderNames
        if !names.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Button { withAnimation(.easeInOut(duration: 0.15)) { placeholdersOpen.toggle() } } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .rotationEffect(.degrees(placeholdersOpen ? 90 : 0))
                        Text(t("ed_placeholders")).font(.subheadline.bold())
                        Text("\(names.count)").font(.system(size: 11)).foregroundStyle(.secondary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if placeholdersOpen {
                ForEach(names, id: \.self) { name in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(name)
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 140, alignment: .leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        TextField(t("ph_desc"), text: Binding(
                            get: { note.hints[name] ?? "" },
                            set: { note.hints[name] = $0 }), axis: .vertical)
                            .lineLimit(1...6)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                }
            }
            .padding(.top, 4)
        }
    }

    /// Buang command kosong dan deskripsi placeholder yang sudah tidak dipakai / kosong
    func cleaned() -> Note {
        var n = note
        n.commands = n.commands.filter { !$0.code.isEmpty }
        let names = Set(placeholderNames)
        n.hints = n.hints.filter { names.contains($0.key) && !$0.value.trimmingCharacters(in: .whitespaces).isEmpty }
        return n
    }

    func commandEditor(_ cmd: Binding<Command>) -> some View {
        let cid = cmd.wrappedValue.id
        let idx = note.commands.firstIndex(where: { $0.id == cid }) ?? 0
        let multi = note.commands.count > 1
        let expanded = expandedCmds.contains(cid)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                if multi {
                    Text("\(idx + 1).").font(.system(size: 12, weight: .semibold)).foregroundStyle(.secondary)
                }
                TextField(t("f_label"), text: cmd.label).textFieldStyle(.roundedBorder)
                Picker("", selection: cmd.lang) {
                    ForEach(Highlighter.languages, id: \.self) { Text($0).tag($0) }
                }
                .labelsHidden()
                .frame(width: 110)
                expandButton(expanded) {
                    if expanded { expandedCmds.remove(cid) } else { expandedCmds.insert(cid) }
                }
                if multi {
                    Button { move(idx, -1) } label: { Image(systemName: "arrow.up") }
                        .disabled(idx == 0)
                    Button { move(idx, 1) } label: { Image(systemName: "arrow.down") }
                        .disabled(idx >= note.commands.count - 1)
                    Button(role: .destructive) { note.commands.removeAll { $0.id == cid } } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            CodeEditor(text: cmd.code)
                .frame(height: editorHeight(cmd.wrappedValue.code, expanded: expanded, base: multi ? 90 : 140))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary.opacity(0.3)))
            if !cmd.wrappedValue.code.isEmpty {
                CodeBlock(code: cmd.wrappedValue.code, lang: cmd.wrappedValue.lang, maxLines: 8)
            }
        }
        .padding(multi ? 10 : 0)
        .background(RoundedRectangle(cornerRadius: 8).fill(multi ? Color.secondary.opacity(0.08) : Color.clear))
    }

    func move(_ i: Int, _ d: Int) {
        let j = i + d
        guard note.commands.indices.contains(i), note.commands.indices.contains(j) else { return }
        note.commands.swapAt(i, j)
    }
}

struct SettingsView: View {
    @ObservedObject var store: Store
    @ObservedObject var settings: Settings
    var onBack: () -> Void

    @State private var recording = false
    @State private var monitor: Any?
    @State private var loginEnabled = SMAppService.mainApp.status == .enabled
    @State private var info: String?
    @State private var showRestorePicker = false
    @State private var backupError: String?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { onBack() } label: { Label(t("back"), systemImage: "chevron.left") }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.cancelAction)
                    .frame(width: 90, alignment: .leading)
                Spacer()
                Text(t("settings")).font(.headline)
                Spacer()
                Color.clear.frame(width: 90, height: 1)
            }
            .padding(14)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    dataSection
                    backupSection
                    suggestSection
                    hotkeySection
                    generalSection
                    languageSection
                    if let i = info {
                        Text(i).font(.system(size: 12)).foregroundStyle(Color.accentColor)
                    }
                }
                .padding(16)
            }
        }
        .onDisappear { stopRecording() }
    }

    var dataSection: some View {
        GroupBox(label: Text(t("sec_data")).font(.subheadline.bold())) {
            VStack(alignment: .leading, spacing: 8) {
                Text(t("data_note")).font(.system(size: 11)).foregroundStyle(.secondary)
                Text(Store.dataFile.path)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineLimit(2).truncationMode(.middle)
                    .textSelection(.enabled)
                HStack {
                    Button(t("export")) { info = DataTransfer.exportFile(store) }
                    Button(t("import")) { info = DataTransfer.importFile(store) }
                    Spacer()
                    Button(t("open_finder")) {
                        NSWorkspace.shared.activateFileViewerSelecting([Store.dataFile])
                    }
                }
                .disabled(store.isLoading)
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var backupSection: some View {
        GroupBox(label: Text(t("sec_backup")).font(.subheadline.bold())) {
            VStack(alignment: .leading, spacing: 8) {
                Text(t("backup_desc")).font(.system(size: 11)).foregroundStyle(.secondary)
                Picker(t("sec_backup"), selection: $settings.backupInterval) {
                    ForEach(BackupInterval.allCases) { opt in
                        Text(opt.label).tag(opt)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .frame(maxWidth: 280)
                HStack {
                    Button(t("backup_now")) { runBackup() }
                    Button(t("backup_restore")) { showRestorePicker = true }
                    Spacer()
                }
                .disabled(store.isLoading)
                if let last = settings.lastBackupAt {
                    Text(t("backup_last", DateFormatter.localizedString(from: last, dateStyle: .medium, timeStyle: .short)))
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                if let e = backupError {
                    Text(e).font(.system(size: 11)).foregroundStyle(.red)
                }
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $showRestorePicker) {
            RestorePickerView(store: store, onDone: { msg in
                showRestorePicker = false
                info = msg
            })
        }
    }

    func runBackup() {
        backupError = nil
        do {
            try BackupManager.backupNow(store)
            settings.lastBackupAt = Date()
            info = t("backup_ok")
        } catch {
            backupError = t("backup_fail") + error.localizedDescription
        }
    }

    var hotkeySection: some View {
        GroupBox(label: Text(t("sec_hotkey")).font(.subheadline.bold())) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(t("toggle_panel"))
                    Spacer()
                    Button(recording ? t("press_keys") : settings.hotkeyLabel) {
                        recording ? stopRecording() : startRecording()
                    }
                    .font(.system(size: 13, design: .monospaced))
                    Button(t("reset")) { settings.resetHotkey() }
                }
                Text(t("hotkey_hint")).font(.system(size: 11)).foregroundStyle(.secondary)
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var generalSection: some View {
        GroupBox(label: Text(t("sec_general")).font(.subheadline.bold())) {
            VStack(alignment: .leading, spacing: 10) {
                Toggle(t("bg"), isOn: $settings.runInBackground)
                if !settings.runInBackground {
                    Text(t("bg_desc")).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Toggle(t("hide_icon"), isOn: $settings.hideMenuIcon)
                if settings.hideMenuIcon {
                    Text(t("hide_icon_desc")).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Toggle(t("login"), isOn: Binding(
                    get: { loginEnabled },
                    set: { v in
                        do {
                            if v { try SMAppService.mainApp.register() }
                            else { try SMAppService.mainApp.unregister() }
                            info = nil
                        } catch {
                            info = error.localizedDescription
                        }
                        loginEnabled = SMAppService.mainApp.status == .enabled
                    }))
                Text(t("login_desc")).font(.system(size: 11)).foregroundStyle(.secondary)
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var suggestSection: some View {
        GroupBox(label: Text(t("sec_suggest")).font(.subheadline.bold())) {
            VStack(alignment: .leading, spacing: 8) {
                Text(t("suggest_desc")).font(.system(size: 11)).foregroundStyle(.secondary)
                CodeEditor(text: $settings.placeholderRules)
                    .frame(height: 110)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary.opacity(0.3)))
                Button(t("clear_recent")) {
                    PlaceholderMemory.clearRecent()
                    info = t("recent_cleared")
                }
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var languageSection: some View {
        GroupBox(label: Text(t("sec_lang")).font(.subheadline.bold())) {
            Picker(t("language"), selection: $settings.language) {
                Text("Bahasa Indonesia").tag(Lang.idn)
                Text("English").tag(Lang.en)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(6)
        }
    }

    // MARK: actions

    func startRecording() {
        recording = true
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { e in
            self.handle(e)
            return nil
        }
    }

    func stopRecording() {
        recording = false
        if let m = monitor { NSEvent.removeMonitor(m); monitor = nil }
    }

    func handle(_ e: NSEvent) {
        let flags = e.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if Int(e.keyCode) == kVK_Escape && flags.isEmpty { stopRecording(); return }
        var mods = 0
        if flags.contains(.command) { mods |= cmdKey }
        if flags.contains(.shift) { mods |= shiftKey }
        if flags.contains(.option) { mods |= optionKey }
        if flags.contains(.control) { mods |= controlKey }
        if mods == 0 { info = t("need_modifier"); return }
        settings.hotkeyCode = Int(e.keyCode)
        settings.hotkeyMods = mods
        settings.hotkeyLabel = modSymbols(flags) + keyName(e)
        info = nil
        stopRecording()
    }
}

// MARK: - Restore dari backup iCloud

struct RestorePickerView: View {
    @ObservedObject var store: Store
    var onDone: (String?) -> Void
    @State private var entries: [BackupManager.Entry] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(t("backup_pick_title")).font(.headline).padding(14)
            Divider()
            if entries.isEmpty {
                Text(t("backup_none")).font(.system(size: 12)).foregroundStyle(.secondary).padding(14)
            } else {
                List(entries) { e in
                    Button(e.label) { restore(e) }
                        .buttonStyle(.plain)
                }
            }
            Divider()
            HStack {
                Spacer()
                Button(t("cancel")) { onDone(nil) }.keyboardShortcut(.cancelAction)
            }
            .padding(10)
        }
        .frame(width: 320, height: 260)
        .onAppear { entries = BackupManager.list() }
    }

    func restore(_ e: BackupManager.Entry) {
        guard let incoming = BackupManager.notes(at: e.url) else { return }
        let a = NSAlert()
        a.messageText = t("backup_restore_q", e.label)
        a.informativeText = t("import_q_desc")
        a.addButton(withTitle: t("merge"))
        a.addButton(withTitle: t("replace"))
        a.addButton(withTitle: t("cancel"))
        switch a.runModal() {
        case .alertFirstButtonReturn: store.importNotes(incoming, replace: false)
        case .alertSecondButtonReturn: store.importNotes(incoming, replace: true)
        default: return
        }
        onDone(t("import_ok").replacingOccurrences(of: "%d", with: "\(incoming.count)"))
    }
}

// MARK: - Ekspor / impor file

enum DataTransfer {
    static func filename() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyyMMdd"
        return "cheatsheet-\(f.string(from: Date())).json"
    }

    /// Mengembalikan pesan status, atau nil kalau dibatalkan
    static func exportFile(_ store: Store) -> String? {
        NSApp.activate(ignoringOtherApps: true)
        let p = NSSavePanel()
        p.allowedContentTypes = [.json]
        p.nameFieldStringValue = filename()
        p.canCreateDirectories = true
        guard p.runModal() == .OK, let url = p.url else { return nil }
        do {
            try store.export(to: url)
            return t("export_ok").replacingOccurrences(of: "%d", with: "\(store.notes.count)")
        } catch {
            return t("export_fail") + error.localizedDescription
        }
    }

    static func importFile(_ store: Store) -> String? {
        NSApp.activate(ignoringOtherApps: true)
        let p = NSOpenPanel()
        p.allowedContentTypes = [.json]
        p.allowsMultipleSelection = false
        p.canChooseDirectories = false
        guard p.runModal() == .OK, let url = p.url else { return nil }
        guard let data = try? Data(contentsOf: url), let incoming = Store.decode(data) else {
            return t("import_fail")
        }
        let a = NSAlert()
        a.messageText = t("import_q").replacingOccurrences(of: "%d", with: "\(incoming.count)")
        a.informativeText = t("import_q_desc")
        a.addButton(withTitle: t("merge"))
        a.addButton(withTitle: t("replace"))
        a.addButton(withTitle: t("cancel"))
        switch a.runModal() {
        case .alertFirstButtonReturn: store.importNotes(incoming, replace: false)
        case .alertSecondButtonReturn: store.importNotes(incoming, replace: true)
        default: return nil
        }
        return t("import_ok").replacingOccurrences(of: "%d", with: "\(incoming.count)")
    }
}

// MARK: - Floating panel

final class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

// MARK: - App delegate

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    let store = Store()
    let state = AppState()
    let settings = Settings.shared
    var panel: FloatingPanel!
    var statusItem: NSStatusItem!
    var bag = Set<AnyCancellable>()
    var backupTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        buildMainMenu()
        buildPanel()
        buildStatusItem()
        HotKeyCenter.shared.handler = { [weak self] in self?.toggle() }
        bind()
        scheduleAutoBackup()

        // Kalau baru login (boot kurang dari 3 menit) dan open at login aktif, mulai tersembunyi
        let justBooted = ProcessInfo.processInfo.systemUptime < 180
        if !(justBooted && SMAppService.mainApp.status == .enabled) {
            showPanel()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.flush()
    }

    /// Cek tiap jam apakah backup otomatis sudah jatuh tempo (dipanggil juga langsung saat launch).
    func scheduleAutoBackup() {
        checkAutoBackup()
        backupTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.checkAutoBackup()
        }
    }

    func checkAutoBackup() {
        guard let interval = settings.backupInterval.seconds else { return }
        guard !store.isLoading else { return }
        if let last = settings.lastBackupAt, Date().timeIntervalSince(last) < interval { return }
        do {
            try BackupManager.backupNow(store)
            settings.lastBackupAt = Date()
        } catch {
            NSLog("CheatSheet auto backup failed: \(error)")
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showPanel()
        return true
    }

    func bind() {
        Publishers.CombineLatest(settings.$hotkeyCode, settings.$hotkeyMods)
            .receive(on: DispatchQueue.main)
            .sink { code, mods in HotKeyCenter.shared.register(keyCode: code, modifiers: mods) }
            .store(in: &bag)

        settings.$hideMenuIcon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hide in self?.statusItem.isVisible = !hide }
            .store(in: &bag)

        Publishers.MergeMany(
            settings.$language.map { _ in () }.eraseToAnyPublisher(),
            settings.$hotkeyLabel.map { _ in () }.eraseToAnyPublisher(),
            state.$pinned.map { _ in () }.eraseToAnyPublisher()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in self?.rebuildMenu() }
        .store(in: &bag)
    }

    func buildPanel() {
        let view = ContentView(store: store, state: state, onClose: { [weak self] in self?.hidePanel() })
        let p = FloatingPanel(
            contentRect: NSRect(x: 0, y: 0, width: 820, height: 560),
            styleMask: [.titled, .fullSizeContentView, .resizable, .closable, .nonactivatingPanel],
            backing: .buffered, defer: false)
        p.titleVisibility = .hidden
        p.titlebarAppearsTransparent = true
        p.isMovableByWindowBackground = true
        p.level = .floating
        p.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        p.hidesOnDeactivate = false
        p.isReleasedWhenClosed = false
        p.delegate = self
        p.contentView = NSHostingView(rootView: view)
        panel = p
    }

    func buildStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "list.bullet.rectangle",
                                           accessibilityDescription: "CheatSheet")
        statusItem.isVisible = !settings.hideMenuIcon
        rebuildMenu()
    }

    func menuItem(_ title: String, _ action: Selector, key: String = "") -> NSMenuItem {
        let i = NSMenuItem(title: title, action: action, keyEquivalent: key)
        i.target = self
        return i
    }

    func rebuildMenu() {
        let menu = NSMenu()
        menu.addItem(menuItem("\(t("menu_toggle")) (\(settings.hotkeyLabel))", #selector(toggleAction)))
        let pin = menuItem(t("menu_pin"), #selector(togglePin))
        pin.state = state.pinned ? .on : .off
        menu.addItem(pin)
        menu.addItem(menuItem(t("menu_settings"), #selector(openSettings)))
        menu.addItem(.separator())
        menu.addItem(menuItem(t("menu_export"), #selector(exportAction)))
        menu.addItem(menuItem(t("menu_import"), #selector(importAction)))
        menu.addItem(menuItem(t("menu_open"), #selector(revealNotes)))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: t("menu_quit"), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    func buildMainMenu() {
        let main = NSMenu()
        let appItem = NSMenuItem(); main.addItem(appItem)
        let appMenu = NSMenu(); appItem.submenu = appMenu
        appMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        let editItem = NSMenuItem(); main.addItem(editItem)
        let edit = NSMenu(title: "Edit"); editItem.submenu = edit
        edit.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        edit.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        edit.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        edit.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        edit.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        NSApp.mainMenu = main
    }

    @objc func toggleAction() { toggle() }
    @objc func togglePin() { state.pinned.toggle() }
    @objc func openSettings() { showPanel(openSettings: true) }
    @objc func revealNotes() { NSWorkspace.shared.activateFileViewerSelecting([Store.dataFile]) }
    @objc func exportAction() { report(DataTransfer.exportFile(store)) }
    @objc func importAction() { report(DataTransfer.importFile(store)) }

    func report(_ msg: String?) {
        guard let msg = msg else { return }
        let a = NSAlert()
        a.messageText = msg
        a.runModal()
    }

    func toggle() {
        if panel.isVisible && panel.isKeyWindow { hidePanel() } else { showPanel() }
    }

    func showPanel(openSettings: Bool = false) {
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main
        if let f = screen?.visibleFrame {
            let size = panel.frame.size
            panel.setFrameOrigin(NSPoint(x: f.midX - size.width / 2,
                                         y: f.midY - size.height / 2 + f.height * 0.08))
        }
        panel.makeKeyAndOrderFront(nil)
        state.wantSettings = openSettings
        state.focusTick += 1
    }

    func hidePanel() {
        panel.orderOut(nil)
        if !settings.runInBackground { NSApp.terminate(nil) }
    }

    func windowDidResignKey(_ notification: Notification) {
        if !state.pinned && !state.busy { hidePanel() }
    }
}

// MARK: - Entry point

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()