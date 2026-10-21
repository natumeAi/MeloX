import SwiftUI

/// Keeps the now-playing row within reach when it scrolls off screen.
private struct MusicCollectionNowPlayingLocator: ViewModifier {
    let trackIDs: [Int]
    let isEnabled: Bool

    @Environment(PlayerStore.self) private var player
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion

    @State private var visibleTrackIDs: Set<Int> = []
    @State private var scrollPosition = ScrollPosition(idType: Int.self)

    func body(content: Content) -> some View {
        content
            .scrollPosition($scrollPosition)
            .onScrollTargetVisibilityChange(idType: Int.self, threshold: 0.5) { ids in
                visibleTrackIDs = Set(ids)
            }
            .overlay(alignment: .bottomTrailing) {
                if let locatableSongID {
                    locateButton(songID: locatableSongID)
                        .padding(.trailing, 20)
                        .padding(.bottom, 16)
                        .transition(.opacity)
                }
            }
            .animation(
                accessibilityReduceMotion ? nil : .easeOut(duration: 0.18),
                value: locatableSongID
            )
    }

    private var locatableSongID: Int? {
        guard isEnabled,
              let id = player.currentSong?.id,
              trackIDs.contains(id),
              !visibleTrackIDs.contains(id)
        else { return nil }
        return id
    }

    private func locateButton(songID: Int) -> some View {
        Button {
            withAnimation(accessibilityReduceMotion ? nil : .smooth) {
                scrollPosition.scrollTo(id: songID, anchor: .center)
            }
        } label: {
            Image(systemName: "scope")
                .font(.title3.weight(.semibold))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .accessibilityLabel("ui.player.locate_now_playing")
    }
}

extension View {
    func musicCollectionNowPlayingLocator(
        trackIDs: [Int],
        isEnabled: Bool
    ) -> some View {
        modifier(
            MusicCollectionNowPlayingLocator(
                trackIDs: trackIDs,
                isEnabled: isEnabled
            )
        )
    }
}
