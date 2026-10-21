import Foundation

enum LyricsLiveActivityDeepLink {
    nonisolated static let nowPlayingURL = URL(string: "melox://now-playing")!

    nonisolated static func isNowPlaying(_ url: URL) -> Bool {
        url.scheme?.lowercased() == "melox"
            && url.host?.lowercased() == "now-playing"
    }
}
