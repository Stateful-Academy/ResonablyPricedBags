//
//  FirebaseStorageService.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation
import UIKit
import FirebaseStorage
/// Protocol we will use to create proper `Dependency Inversion` Used specially for accessing Storage ( images )
protocol FirebaseStorageServiceable {
    func saveImage(with docID: String, from imageData: Data, handler: @escaping(Result<Bool, FirebaseError>) -> Void)
    func fetchImage(with docID: String, handler: @escaping(Result<UIImage, FirebaseError>) -> Void)
}

struct FirebaseStorageService: FirebaseStorageServiceable {
    let storageRef = Storage.storage().reference().child(Constants.Images.imagePath)
    
    func saveImage(with docID: String, from imageData: Data, handler: @escaping (Result<Bool, FirebaseError>) -> Void) {
        /// Use this to be able to preview the image on the Storage Console
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        /// Storage Console ^^
        storageRef.child(docID).putData(imageData, metadata: uploadMetadata) { result in
            switch result {
            case .success(_):
                handler(.success(true))
            case .failure(let failure):
                handler(.failure(.firebaseError(failure)))
            }
        }
    }
    
    func fetchImage(with docID: String, handler: @escaping (Result<UIImage, FirebaseError>) -> Void) {
        storageRef.child(docID).getData(maxSize: 1024 * 1024) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {return}
                handler(.success(image))
            case .failure(let failure):
                handler(.failure(.firebaseError(failure)))
            }
        }
    }
} // Struct
