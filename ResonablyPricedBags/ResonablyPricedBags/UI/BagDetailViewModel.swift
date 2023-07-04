//
//  BagDetailViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct BagDetailViewModel {
    
    
    func create(name: String, price: Double, season: String, origin: String, gender: String) {
        
        let sizeDict = Size(small: "is smol", medium: "mild?", large: "chonky")
        
        let colors = [Color(colorName: "blue"), Color(colorName: "Red")]
        
        let bag = Bag(name: name, price: price, season: season, originLocation: origin, gender: gender,  collectionType: "bags", size: sizeDict, colors: colors)
        
        save(parameterBagName: bag)
    }
    
    func save(parameterBagName: Bag) {
        let ref = Firestore.firestore()
        do {
            try ref.collection(parameterBagName.collectionType).addDocument(from: parameterBagName)
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
    
    func fetchAllBags() {
        let db = Firestore.firestore()
        db.collection("bags").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            do {
                let bagsArray = try documents.compactMap({ try $0.data(as: Bag.self)})
                print(bagsArray)
            } catch {
                print("oh no!", error.localizedDescription)
            }
        }
    }
}
