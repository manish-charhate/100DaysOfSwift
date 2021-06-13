//
//  ViewModelProvider.swift
//  PersistentImageGallery
//
//  Created by Manish Charhate on 13/06/21.
//

import Foundation
import UIKit

protocol DataManagerDelegate: class {

    func modelsDidUpdate()
}

class DataManager {

    var models: [PhotoModel]
    let userDefaults = UserDefaults.standard
    weak var delegate: DataManagerDelegate?

    init(delegate: DataManagerDelegate?) {
        self.delegate = delegate
        if let data = userDefaults.data(forKey: "GalleryData"),
           let models = try? JSONDecoder().decode([PhotoModel].self, from: data) {
            self.models = models
        } else {
            models = []
        }
    }

    func addNewModel(with image: UIImage?, caption: String?) {
        guard let image = image,
              let caption = caption else {
            return
        }

        let imageName = UUID().uuidString
        let filePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: filePath)
            } catch {
                print("Could not write data to disk")
            }
        }

        let model = PhotoModel(imageName: imageName, caption: caption)
        models.append(model)
        delegate?.modelsDidUpdate()
        saveToUserDefaults()
    }

    func extractImage(with name: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(name)
        if let data = try? Data(contentsOf: filePath) {
            return UIImage(data: data)
        }
        return nil
    }

    private func getDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }

    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(models) {
            userDefaults.set(encodedData, forKey: "GalleryData")
        }
    }

}
