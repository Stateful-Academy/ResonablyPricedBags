//
//  BagDetailViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

protocol BagDetailViewModelDelegate: BagDetailViewController {
     func imageLoadedSuccessfully()
}

class BagDetailViewModel {
    
    var bag: Bag?
    var image: UIImage?
    weak var delegate: BagDetailViewModelDelegate?
    
    init(bag: Bag?, injectedDelegate: BagDetailViewModelDelegate) {
        self.bag = bag
        self.delegate = injectedDelegate
        self.fetchImage(with: bag?.id)
    }
    
    func create(name: String, price: Double, season: String, origin: String, gender: String, handler: @escaping (Result<String,FirebaseError>) -> Void) {
        
        let sizeDict = Size(small: "is smol", medium: "mild?", large: "chonky")
        
        let colors = [Color(colorName: "blue"), Color(colorName: "Red")]
        
        let bag = Bag(name: name, price: price, season: season, originLocation: origin, gender: gender,  collectionType: Constants.Bags.bagsCollectionPath, size: sizeDict, colors: colors)
        
        save(parameterBagName: bag) { result in
            switch result {
            case .success(let docID):
                handler(.success(docID))
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func save(parameterBagName: Bag, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        let ref = Firestore.firestore()
        do {
            let documentRef = try ref.collection(Constants.Bags.bagsCollectionPath).addDocument(from: parameterBagName, completion: { _ in
            })
            print(documentRef)
            completion(.success(documentRef.documentID))
        } catch {
            print("Oh shittttt. Something went wrong", error.localizedDescription)
            return
        }
    }
    
    // Fetches single bag
//    func fetch(parameterDocID: String) {
//        let db = Firestore.firestore()
//        let path = db.collection("bags").document(parameterDocID)
//        path.getDocument(as: Bag.self) { result in
//            switch result {
//            case .success(let success):
//                print(success.name)
//            case .failure(let failure):
//                print("oh no!", failure.localizedDescription)
//            }
//        }
//    }
    
    func saveImage(with image: UIImage, to docID: String) {
        
        // convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        // build
        let storageRef = Storage.storage().reference()
        /// Use this to be able to preview the image on the Storage Console
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        /// Storage Console ^^
       
        storageRef.child(Constants.Images.imagePath).child(docID).putData(imageData, metadata: uploadMetadata) { result in
            switch result {
            case .success(let metaData):
                let imagePath = metaData.path
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    } // End of the save Image
    
    func fetchImage(with id: String?) {
        // where are we trying to fetch the image from?
        guard let id else {return}
        let storageRef = Storage.storage().reference()
        
        storageRef.child(Constants.Images.imagePath).child(id).getData(maxSize: 1024 * 1024) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {return}
                self.image = image
                self.delegate?.imageLoadedSuccessfully()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    
    
    
} // End of the class
