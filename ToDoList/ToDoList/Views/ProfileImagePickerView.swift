//
//  ProfileImagePickerView.swift
//  ToDoList
//
//  Created by David E Bratton on 4/11/20.
//  Copyright © 2020 David E Bratton. All rights reserved.
//

import SwiftUI

struct ProfileImagePickerView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var image: Image?
    @Binding var fbImage: UIImage?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image, fbImage: $fbImage)
    }
}
