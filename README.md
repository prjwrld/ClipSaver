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

Here’s how ClipSaver looks in action:

### 📋 Menu Bar Popover
![Menu Bar Popover](https://github.com/prjwrld/ClipSaver/blob/main/Photos/clipSaver-menu-bar.png?raw=true)

### 🪟 App Window View
![Application Window](https://github.com/prjwrld/ClipSaver/blob/main/Photos/clipSaver-application-window.png?raw=true)

### 🔁 Alternate Menu View
![Alternate Menu Bar](https://github.com/prjwrld/ClipSaver/blob/main/Photos/clipSaver-menu-bar1.png?raw=true)

---

## ⚙️ Installation

**DMG Build:**
> [📦 Download ClipSaver v1.0.0 (.dmg)](https://github.com/prjwrld/ClipSaver/releases/download/v1.0.0/ClipSaver.dmg)

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
