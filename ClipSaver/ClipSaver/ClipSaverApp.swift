import SwiftUI

@main
struct ClipSaverApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No default window group — menu bar controls visibility
        Settings {} // Allows access to app settings if needed
    }
}
