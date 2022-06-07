import SwiftUI
import PhotosUI

struct LivePhoto: UIViewRepresentable {
  let livePhoto: PHLivePhoto

  func makeUIView(context: Context) -> PHLivePhotoView {
    let livePhotoView = PHLivePhotoView()
    livePhotoView.livePhoto = livePhoto
    return livePhotoView
  }
  
  func updateUIView(_ livePhotoView: PHLivePhotoView, context: Context) {
  }
}
