import SwiftUI
import PhotosUI

public struct PhotoPicker: UIViewControllerRepresentable {
  @Binding public var results: [PhotoResult]
  @Binding public var didPickPhoto: Bool

  public init(results: Binding<[PhotoResult]>, didPickPhoto: Binding<Bool>) {
    self._results = results
    self._didPickPhoto = didPickPhoto
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.preselectedAssetIdentifiers = results.map { $0.id }
    configuration.selectionLimit = 0
    configuration.preferredAssetRepresentationMode = .current
    configuration.selection = .ordered

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
  }

  public func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  public class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    var parent: PhotoPicker

    init(_ parent: PhotoPicker) {
      self.parent = parent
    }

    private func loadPhotos(results: [PHPickerResult]) async throws {
      let existingSelection = parent.results

      parent.results = []

      for result in results {
        let id = result.assetIdentifier!
        let firstItem = existingSelection.first(where: { $0.id == id })

        var item = firstItem?.item

        if item == nil {
          item = try await result.itemProvider.loadPhoto()
        }

        let newResult: PhotoResult = .init(id: id, item: item!)

        parent.results.append(newResult)
      }
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)

      Task {
        do {
          try await loadPhotos(results: results)
          parent.didPickPhoto = true
        } catch {
          print(error)
        }
      }
    }
  }
}
