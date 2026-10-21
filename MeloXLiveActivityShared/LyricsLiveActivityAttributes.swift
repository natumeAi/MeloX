import ActivityKit
import Foundation

enum LyricsLiveActivityStyle: String, Codable, Hashable {
    case lyrics
    case nowPlaying
}

enum LyricsLiveActivityCompactTextSize:
    String,
    Codable,
    Hashable,
    CaseIterable,
    Identifiable {
    case small
    case standard
    case large

    var id: Self { self }

    var pointSize: Double {
        switch self {
        case .small: 10
        case .standard: 12
        case .large: 14
        }
    }
}

struct LyricsLiveActivityPresentation: Codable, Hashable {
    static let nowPlayingCard = LyricsLiveActivityPresentation(
        showsArtwork: true,
        showsNextLyric: false,
        showsProgress: true,
        scrollsCompactText: false,
        compactTextSize: .standard,
        scrollSpeed: 0,
        scrollPause: 0
    )

    let showsArtwork: Bool
    let showsNextLyric: Bool
    let showsProgress: Bool
    let scrollsCompactText: Bool
    let compactTextSize: LyricsLiveActivityCompactTextSize
    let scrollSpeed: Double
    let scrollPause: TimeInterval
}

struct LyricsLiveActivityAttributes: ActivityAttributes {
    static let currentSchemaVersion = 2

    struct ContentState: Codable, Hashable {
        let title: String
        let subtitle: String
        let compactText: String
        let compactScrollOffset: Int
        let compactScrollDistance: Double?
        let nextLyric: String?
        let artworkData: Data?
        let presentation: LyricsLiveActivityPresentation
        let isPlaying: Bool
        let playbackPosition: TimeInterval
        let duration: TimeInterval
        let updatedAt: Date
        /// Older activities omit this field and keep the lyrics presentation.
        let style: LyricsLiveActivityStyle?

        var progress: Double {
            guard duration > 0 else { return 0 }
            return min(max(playbackPosition / duration, 0), 1)
        }

        var playbackInterval: ClosedRange<Date>? {
            guard isPlaying, duration > 0 else { return nil }
            let start = updatedAt.addingTimeInterval(-playbackPosition)
            return start...start.addingTimeInterval(duration)
        }
    }

    let sessionID: UUID
    let schemaVersion: Int?
}
