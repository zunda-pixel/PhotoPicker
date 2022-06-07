import UIKit
import AVFoundation

extension UIImage {
  static func thumbnail(movieURL url: URL) async throws -> Self {
    let asset: AVAsset = .init(url: url)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true

    do {
      let duration = try await asset.load(.duration)
      let cgImage = try generator.copyCGImage(at: duration, actualTime: nil)
      return self.init(cgImage: cgImage)
    } catch {
      throw PhotoError.generateThumbnail
    }
  }
}
