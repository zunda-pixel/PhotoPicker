import Foundation
import PhotosUI

extension NSItemProvider {
  public func loadPhoto() async throws -> Any {
    if self.canLoadObject(ofClass: PHLivePhoto.self) {
      return try await self.loadObject(ofClass: PHLivePhoto.self)
    }

    else if self.canLoadObject(ofClass: UIImage.self) {
      return try await self.loadObject(ofClass: UIImage.self)
    }

    else if self.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
      let moviePath = try await self.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier)
      let thumbnail = try await UIImage.thumbnail(videoPath: moviePath)
      let movie: Movie = .init(path: moviePath, thumbnail: thumbnail)
      return movie
    }

    throw PhotoError.missingData
  }

  fileprivate func loadFileRepresentation(forTypeIdentifier typeIdentifier: String) async throws -> URL {
    try await withCheckedThrowingContinuation { continuation in
      self.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        guard let url = url else {
          return continuation.resume(throwing: PhotoError.missingData)
        }

        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: localURL)

        do {
          try FileManager.default.copyItem(at: url, to: localURL)
        } catch {
          return continuation.resume(throwing: error)
        }

        continuation.resume(returning: localURL)
      }.resume()
    }
  }

  fileprivate func loadObject(ofClass aClass : NSItemProviderReading.Type) async throws -> NSItemProviderReading {
    try await withCheckedThrowingContinuation { continuation in
      self.loadObject(ofClass: aClass) { data, error in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        guard let data = data else {
          return continuation.resume(throwing: PhotoError.missingData)
        }

        continuation.resume(returning: data)
      }.resume()
    }
  }
}
