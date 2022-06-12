import SwiftUI
import PhotosUI


public struct PhotosPicker: View {
  @State var isPresented = false
  @Binding var results: [PHPickerResult]
  let configuration: PHPickerConfiguration

  init(selection: Binding<[PHPickerResult]>,
       maxSelectionCount: Int? = nil,
       selectionBehavior: PHPickerConfiguration.Selection = .default,
       matching filter: PHPickerFilter? = nil,
       preferredItemEncoding: PHPickerConfiguration.AssetRepresentationMode = .automatic,
       photoLibrary: PHPhotoLibrary
   ) {

    self._results = selection

    var configuration: PHPickerConfiguration = .init(photoLibrary: photoLibrary)
    configuration.preselectedAssetIdentifiers = selection.wrappedValue.compactMap(\.assetIdentifier)

    if let maxSelectionCount {
      configuration.selectionLimit = maxSelectionCount
    }
    
    configuration.selection = selectionBehavior
    configuration.filter = filter
    configuration.preferredAssetRepresentationMode = preferredItemEncoding

    self.configuration = configuration
  }

  public var body: some View {
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
