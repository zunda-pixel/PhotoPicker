import SwiftUI
import PhotosUI


public struct PhotosPicker<Label: View>: View {
  @State var isPresented = false
  @Binding var results: [PHPickerResult]
  let configuration: PHPickerConfiguration

  let label: Label
  public init(selection: Binding<[PHPickerResult]>,
       maxSelectionCount: Int? = nil,
       selectionBehavior: PHPickerConfiguration.Selection = .default,
       matching filter: PHPickerFilter? = nil,
       preferredItemEncoding: PHPickerConfiguration.AssetRepresentationMode = .automatic,
       photoLibrary: PHPhotoLibrary, @ViewBuilder label: () -> Label
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

    self.label = label()
  }

  public var body: some View {
    Button {
      isPresented.toggle()
    } label: {
      label
    }
    .sheet(isPresented: $isPresented) {
      PHPickerView(results: $results, configuration: configuration)
    }
  }
}
