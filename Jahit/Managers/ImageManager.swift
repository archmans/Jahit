//
//  ImageManager.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 20/06/25.
//

import SwiftUI
import Foundation

class ImageManager: ObservableObject {
    static let shared = ImageManager()
    
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    private init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ image: UIImage, withName name: String) -> String? {
        let imageURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return nil
        }
        
        do {
            try imageData.write(to: imageURL)
            print("Image saved successfully: \(name)")
            return name
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
    
    func saveImages(_ images: [UIImage]) -> [String] {
        var savedImageNames: [String] = []
        
        for (index, image) in images.enumerated() {
            let imageName = "custom_image_\(UUID().uuidString)_\(index)"
            if let savedName = saveImage(image, withName: imageName) {
                savedImageNames.append(savedName)
            }
        }
        
        return savedImageNames
    }
    
    func loadImage(named name: String) -> UIImage? {
        let imageURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        guard fileManager.fileExists(atPath: imageURL.path) else {
            print("Image file does not exist: \(name)")
            return nil
        }
        
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    func deleteImage(named name: String) -> Bool {
        let imageURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        do {
            try fileManager.removeItem(at: imageURL)
            print("Image deleted successfully: \(name)")
            return true
        } catch {
            print("Failed to delete image: \(error)")
            return false
        }
    }
    
    func deleteImages(named names: [String]) {
        for name in names {
            _ = deleteImage(named: name)
        }
    }
}

extension Image {
    init?(savedImageNamed name: String) {
        guard let uiImage = ImageManager.shared.loadImage(named: name) else {
            return nil
        }
        self.init(uiImage: uiImage)
    }
}
