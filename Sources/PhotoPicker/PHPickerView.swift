//
//  PHPickerView.swift
//  
//
//  Created by zunda on 2022/06/13.
//

import Foundation
import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
  @Binding public var results: [PHPickerResult]
  let configuration: PHPickerConfiguration

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

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      self.parent.results = results
      picker.dismiss(animated: true)
    }
  }
}
