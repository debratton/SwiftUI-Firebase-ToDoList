//
//  ImagePicker.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import Foundation

import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var fbImage: UIImage?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, fbImage: Binding<UIImage?>) {
        _isShown = isShown
        _image = image
        _fbImage = fbImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //image = Image(uiImage: uiImage)
        guard let uiImage = info[.editedImage] as? UIImage else { return }
        fbImage = uiImage
        image = Image(uiImage: uiImage)
        isShown.toggle()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown.toggle()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var fbImage: UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image, fbImage: $fbImage)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
}
