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

struct BagDetailViewModel {
    
    var bag: Bag?
    
    init(bag: Bag?) {
        self.bag = bag
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
        
        storageRef.child(Constants.Images.imagePath).child(docID).putData(imageData) { metaData, error in
            // Handle the Error
            if let error {
                print("SHHHIIIITTTTTTT the image is not working")
                return
            }
        
            let imagePath = metaData?.path
            print(imagePath)
        }
    }
}

/*
 // Data in memory
 let data = Data()

 // Create a reference to the file you want to upload
 let riversRef = storageRef.child("images/rivers.jpg")

 // Upload the file to the path "images/rivers.jpg"
 let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
   guard let metadata = metadata else {
     // Uh-oh, an error occurred!
     return
   }
   // Metadata contains file metadata such as size, content-type.
   let size = metadata.size
   // You can also access to download URL after upload.
   riversRef.downloadURL { (url, error) in
     guard let downloadURL = url else {
       // Uh-oh, an error occurred!
       return
     }
   }
 }
 */
