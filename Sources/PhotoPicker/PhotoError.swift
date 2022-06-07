import Foundation

public enum PhotoError: Error, LocalizedError {
  case generateThumbnail
  case missingData
}
