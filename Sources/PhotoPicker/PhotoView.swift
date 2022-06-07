import SwiftUI
import PhotosUI
import AVKit

public struct PhotoView: View {
  private let item: NSItemProviderReading

  @State var isPresentedVideoPlayer = false
  @State var didError = false
  @State var error: PhotoError?
  @State var photoData: Any?

  public init(item: NSItemProviderReading) {
    self.item = item
  }

  func convertData() async throws -> Any? {
    if let movieURL = item as? URL {
      let uiImage = try await UIImage.thumbnail(movieURL: movieURL)
      return (movieURL, uiImage)
    } else {
      return item
    }
  }

  public var body: some View {
    GeometryReader { geometry in
      if let photoData = photoData {
        switch photoData {
          case let livePhoto as PHLivePhoto:
            LivePhoto(livePhoto: livePhoto)
          case let uiImage as UIImage:
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fit)
          case let movie as (url: URL, image: UIImage):
            ZStack {
              Image(uiImage: movie.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
              Image(systemName: "play")
            }
            .onTapGesture {
              isPresentedVideoPlayer = true
            }
            .sheet(isPresented: $isPresentedVideoPlayer) {
              let player: AVPlayer = .init(url: movie.url)
              VideoPlayer(player: player)
                .onAppear {
                  player.play()
                }
            }
          default:
            Text("Failed Load Error")
        }
      }
    }
    .onAppear {
      Task {
        do {
          photoData = try await convertData()
        } catch let newError as PhotoError{
          self.error = newError
          self.didError.toggle()
        }
      }
    }
    .alert(isPresented: $didError, error: error) {
      Text("load error")
    }
  }
}
