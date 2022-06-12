import SwiftUI
import PhotosUI

struct SamplePhotosPicker: View {
  @State var results: [PHPickerResult] = []

  var body: some View {
    PhotosPicker(results: $results, configuration: .init(photoLibrary: .shared()))
      .onChange(of: results) { newResults in
        print(newResults)
      }
  }
}

struct PhotosPicker: View {
  @State var isPresented = false
  @Binding var results: [PHPickerResult]
  let configuration: PHPickerConfiguration

  init(results: Binding<[PHPickerResult]>, configuration: PHPickerConfiguration) {
    self._results = results
    self.configuration = configuration
  }

  var body: some View {
    Button {
      isPresented.toggle()
    } label: {
      Text("Hello")
    }
    .sheet(isPresented: $isPresented) {
      PHPickerView(results: $results, configuration: configuration)
    }
  }
}

public struct PHPickerView: UIViewControllerRepresentable {
  @Binding public var results: [PHPickerResult]
  var configuration: PHPickerConfiguration

  public init(results: Binding<[PHPickerResult]>, configuration: PHPickerConfiguration) {
    self._results = results
    self.configuration = configuration
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
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
    var parent: PHPickerView

    init(_ parent: PHPickerView) {
      self.parent = parent
    }

    private func loadPhotos(results: [PHPickerResult]) async throws {
      self.parent.results = results
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
    }
  }
}
