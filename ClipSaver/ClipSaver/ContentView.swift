import SwiftUI

struct ContentView: View {
    @StateObject var clipboardManager = ClipboardManager()
    @State private var searchText: String = ""
    @State private var editingClip: String? = nil
    @State private var editedText: String = ""
    @State private var showToast: Bool = false

    var filteredClips: [String] {
        if searchText.isEmpty {
            return clipboardManager.clipboardHistory
        } else {
            return clipboardManager.clipboardHistory.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("📋 Clipboard History")
                .font(.title)

            TextField("Search clipboard...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 4)

            // 💥 Action Buttons
            HStack {
                Spacer()
                Button("🗑️ Clear All") {
                    clipboardManager.clearAll()
                }
                .foregroundColor(.red)

                Button("💾 Save as PDF") {
                    clipboardManager.exportToPDF()
                }
                .foregroundColor(.blue)

                Button("🧹 Reset All Data") {
                    clipboardManager.resetAllData()
                }
                .foregroundColor(.orange)
            }
            .padding(.bottom, 5)

            // ✅ Scrollable List
            List {
                // 📌 Pinned Clips
                if !clipboardManager.pinnedClips.isEmpty {
                    Section(header: Text("📌 Pinned")) {
                        ForEach(clipboardManager.pinnedClips, id: \.self) { item in
                            HStack {
                                if editingClip == item {
                                    TextField("", text: $editedText, onCommit: {
                                        if let index = clipboardManager.pinnedClips.firstIndex(of: item) {
                                            clipboardManager.pinnedClips[index] = editedText
                                            clipboardManager.saveToDisk()
                                        }
                                        editingClip = nil
                                    })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text(item)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(.body, design: clipboardManager.isCodeSnippet(item) ? .monospaced : .default))
                                        .foregroundColor(clipboardManager.isCodeSnippet(item) ? .blue : .primary)
                                        .onTapGesture {
                                            clipboardManager.copyToClipboard(item)
                                        }
                                }

                                Spacer()

                                Button("Edit") {
                                    editingClip = item
                                    editedText = item
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                Button("Unpin") {
                                    clipboardManager.unpinClip(item)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }

                // 📝 Clipboard History
                Section(header: Text("📝 History")) {
                    ForEach(filteredClips, id: \.self) { item in
                        HStack {
                            Text(item)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(.body, design: clipboardManager.isCodeSnippet(item) ? .monospaced : .default))
                                .foregroundColor(clipboardManager.isCodeSnippet(item) ? .blue : .primary)
                                .onTapGesture {
                                    clipboardManager.copyToClipboard(item)
                                }

                            Spacer()

                            Button("Pin") {
                                clipboardManager.pinClip(item)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 600)

        // ✅ Auto-saved Toast Overlay
        .onReceive(NotificationCenter.default.publisher(for: .didSaveClips)) { _ in
            withAnimation {
                showToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                }
            }
        }
        .overlay(
            Group {
                if showToast {
                    Text("✅ Auto-saved")
                        .padding(10)
                        .background(Color.black.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                        .padding(.top, 40)
                }
            },
            alignment: .top
        )
    }
}

#Preview {
    ContentView()
}
