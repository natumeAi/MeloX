import Foundation
import SwiftUI

extension ArtworkDetailPalette {
    var colorScheme: ColorScheme {
        prefersDarkAppearance ? .dark : .light
    }

    var backgroundColor: Color {
        Color(
            red: backgroundRGB.x,
            green: backgroundRGB.y,
            blue: backgroundRGB.z
        )
    }
}

func filterMusicCollectionTracks(_ tracks: [Song], query: String) -> [Song] {
    let terms = query.split(whereSeparator: \.isWhitespace).map(String.init)
    guard !terms.isEmpty else { return tracks }
    let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]

    return tracks.filter { song in
        terms.allSatisfy { term in
            func containsTerm(_ field: String) -> Bool {
                field.range(of: term, options: options) != nil
            }

            return containsTerm(song.name)
                || song.aliases.contains(where: containsTerm)
                || song.artists.contains { artist in
                    containsTerm(artist.name)
                        || artist.aliases.contains(where: containsTerm)
                }
                || (song.album.map { containsTerm($0.name) } ?? false)
        }
    }
}
