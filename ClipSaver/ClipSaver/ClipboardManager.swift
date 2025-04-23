import Foundation
import AppKit
import PDFKit

extension Notification.Name {
    static let didSaveClips = Notification.Name("didSaveClips")
}

class ClipboardManager: ObservableObject {
    @Published var clipboardHistory: [String] = []
    @Published var pinnedClips: [String] = []

    private var lastCopied: String = ""

    // MARK: - Init
    init() {
        loadFromDisk()
        startMonitoring()
    }

    // MARK: - Clipboard Monitoring
    private func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    private func checkClipboard() {
        if let copied = NSPasteboard.general.string(forType: .string),
           copied != lastCopied {
            lastCopied = copied
            DispatchQueue.main.async {
                self.clipboardHistory.insert(copied, at: 0)
                self.saveToDisk()
            }
        }
    }

    // MARK: - Pin / Unpin
    func pinClip(_ clip: String) {
        if !pinnedClips.contains(clip) {
            pinnedClips.insert(clip, at: 0)
            saveToDisk()
        }
    }

    func unpinClip(_ clip: String) {
        pinnedClips.removeAll { $0 == clip }
        saveToDisk()
    }

    // MARK: - Clear / Reset
    func clearAll() {
        clipboardHistory.removeAll()
        pinnedClips.removeAll()
        saveToDisk()
    }

    func resetAllData() {
        clearAll()
        do {
            if FileManager.default.fileExists(atPath: saveFileURL.path) {
                try FileManager.default.removeItem(at: saveFileURL)
                print("🧹 Deleted saved data file.")
            }
        } catch {
            print("❌ Failed to delete saved file: \(error)")
        }
    }

    // MARK: - Code Detection
    func isCodeSnippet(_ text: String) -> Bool {
        let codeHints = ["{", "}", "func", "let", "class", "var", ";", "=>", "import", "#include", "printf", "System.out", "public static", "def ", "if(", "elif"]
        return codeHints.contains(where: text.contains) || text.contains("\n")
    }

    // MARK: - Copy to Clipboard
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    // MARK: - PDF Export
    func exportToPDF() {
        let allClips = (pinnedClips + clipboardHistory)
        let pdfText = allClips.enumerated().map { index, clip in
            return "Clip \(index + 1):\n\(clip)\n\n"
        }.joined()

        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 595, height: 842))
        textView.string = pdfText
        textView.font = NSFont.systemFont(ofSize: 12)

        let printInfo = NSPrintInfo()
        printInfo.paperSize = NSMakeSize(595, 842)
        printInfo.topMargin = 20
        printInfo.leftMargin = 20
        printInfo.rightMargin = 20
        printInfo.bottomMargin = 20

        let printOperation = NSPrintOperation(view: textView, printInfo: printInfo)
        printOperation.showsPrintPanel = false
        printOperation.showsProgressPanel = false

        let data = printOperation.view?.dataWithPDF(inside: textView.bounds) ?? Data()
        let saveURL = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Downloads")
            .appendingPathComponent("ClipSaver_Export.pdf")

        do {
            try data.write(to: saveURL)
            print("✅ PDF saved at: \(saveURL.path)")
        } catch {
            print("❌ Failed to save PDF: \(error)")
        }
    }

    // MARK: - Save / Load JSON
    private var saveFileURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/ClipSaver")
            .appendingPathComponent("clipsaver_data.json")
    }

    struct SavedData: Codable {
        let history: [String]
        let pinned: [String]
    }

    func saveToDisk() {
        let data = SavedData(history: clipboardHistory, pinned: pinnedClips)

        do {
            let folder = saveFileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: saveFileURL)
            print("✅ Saved to disk at \(saveFileURL.path)")

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didSaveClips, object: nil)
            }

        } catch {
            print("❌ Error saving clips: \(error)")
        }
    }

    func loadFromDisk() {
        do {
            let data = try Data(contentsOf: saveFileURL)
            let decoded = try JSONDecoder().decode(SavedData.self, from: data)
            clipboardHistory = decoded.history
            pinnedClips = decoded.pinned
            print("✅ Loaded clips from disk")
        } catch {
            print("⚠️ No saved data found or failed to load: \(error)")
        }
    }
}
