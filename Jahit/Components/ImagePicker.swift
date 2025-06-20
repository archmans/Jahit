//
//  ImagePicker.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 20/06/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    let maxSelection: Int
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = maxSelection
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            print("PHPicker selected \(results.count) items")
            
            // Clear previous selection first
            self.parent.selectedImages.removeAll()
            
            var newImages: [UIImage] = []
            let group = DispatchGroup()
            
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    defer { group.leave() }
                    
                    if let image = object as? UIImage {
                        print("Successfully loaded image")
                        newImages.append(image)
                    } else {
                        print("Failed to load image: \(String(describing: error))")
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("Setting \(newImages.count) images to parent")
                self.parent.selectedImages = newImages
            }
        }
    }
}