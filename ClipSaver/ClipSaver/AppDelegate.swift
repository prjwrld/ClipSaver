import AppKit
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    var mainWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()

        // Set up the popover content
        popover.contentSize = NSSize(width: 420, height: 600)
        popover.behavior = .transient
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)

        // Create status bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "paperclip", accessibilityDescription: "ClipSaver")
            button.action = #selector(togglePopover(_:))
        }

        // Add menu with window support
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "📂 Open Full App", action: #selector(openMainWindow), keyEquivalent: "o"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "❌ Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu

        // Enable auto-launch at login
        enableAutoLaunch()
    }

    // MARK: - Toggle Popover
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    // MARK: - Open Full Window
    @objc func openMainWindow() {
        if mainWindow == nil {
            mainWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 600),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            mainWindow?.center()
            mainWindow?.setFrameAutosaveName("MainWindow")
            mainWindow?.contentView = NSHostingView(rootView: ContentView())
        }
        mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: - Auto-launch at Login
    func enableAutoLaunch() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.register()
                print("✅ ClipSaver set to auto-launch at login.")
            } catch {
                print("❌ Failed to register for login: \(error.localizedDescription)")
            }
        } else {
            print("⚠️ Auto-launch requires macOS 13.0 or newer.")
        }
    }
}
