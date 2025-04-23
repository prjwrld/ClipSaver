# 📋 ClipSaver

**ClipSaver** is a native macOS clipboard manager built with **SwiftUI + AppKit**.  
Designed with a **clean, glass-style UI**, it runs in the **menu bar** and also as a **standalone window** — perfect for developers, writers, and productivity lovers.

---

## 🚀 Features

- 📌 **Clipboard History** – Automatically keeps track of everything you copy
- ⭐ **Pin & Edit Clips** – Save your favorites, edit them in place
- 📤 **Export as PDF** – Instantly save your clips to PDF
- 💎 **Glass-style Interface** – Modern, minimal UI inspired by macOS design
- 🧠 **Intelligent Formatting** – Detects code snippets and renders them in monospaced font
- 🔁 **Auto-launch at Login**
- 🖥️ **Runs in both Menu Bar + Window Mode**

---

## 🖼️ Screenshot

> *(Add a screenshot here of the app running — especially the menu bar popover!)*

---

## ⚙️ Installation

### 🔽 DMG Build

> [Download the latest ClipSaver.dmg](https://github.com/prjwrld/ClipSaver/releases)

### 🛠️ Build from Source (Xcode)

```bash
git clone https://github.com/prjwrld/ClipSaver.git
cd ClipSaver
open ClipSaver.xcodeproj

Then hit ▶️ Run in Xcode to launch the app.

⸻

🧪 Tech Stack
	•	SwiftUI – Views and UI components
	•	AppKit – System integrations (menu bar, popovers)
	•	NSApplicationDelegateAdaptor – Window + lifecycle management
	•	PDFKit – PDF export support
	•	SMAppService – Auto-launch at login (macOS 13+)

⸻

👨‍💻 Author

Made with ❤️ by Prajwal Prasad

⸻

📄 License

This project is open source under the MIT License.
