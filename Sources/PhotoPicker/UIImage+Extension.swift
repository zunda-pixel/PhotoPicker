import UIKit
import AVFoundation

extension UIImage {
  static func thumbnail(videoPath: URL) async throws -> Self {
    let asset: AVAsset = .init(url: videoPath)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true

    let duration = try await asset.load(.duration)
    let cgImage = try generator.copyCGImage(at: duration, actualTime: nil)
    return self.init(cgImage: cgImage)
  }
}
