import SwiftUI
import PhotosUI
import AVKit

public struct PhotoView: View {
  private let item: Any

  @State var isPresentedVideoPlayer = false

  public init(item: Any) {
    self.item = item
  }

  public var body: some View {
    GeometryReader { geometry in
      switch item {
        case let livePhoto as PHLivePhoto:
          LivePhoto(livePhoto: livePhoto)
        case let uiImage as UIImage:
          Image(uiImage: uiImage)
        case let movie as Movie:
          ZStack {
            Image(uiImage: movie.thumbnail)
            Image(systemName: "play")
          }
          .onTapGesture {
            isPresentedVideoPlayer.toggle()
          }
          .sheet(isPresented: $isPresentedVideoPlayer) {
            let player: AVPlayer = .init(url: movie.path)
            VideoPlayer(player: player)
              .onAppear {
                player.play()
              }
          }
        default:
          fatalError()
      }
    }
  }
}
