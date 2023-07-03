//
//  BagDetailViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import Foundation
import FirebaseFirestore


struct BagDetailViewModel {
    
    
    func create(name: String, price: Double, season: String, origin: String, gender: String) {
        let bag = Bag(name: name, price: price, season: season, originLocation: origin, gender: gender)
        save(parameterBagName: bag)
    }
    
    func save(parameterBagName: Bag) {
        let ref = Firestore.firestore()
        ref.collection(parameterBagName.collectionType).document(parameterBagName.uuid).setData(parameterBagName.bagDictionaryReprentation) { error in
            if let error {
                print("Oh shittttt. Something went wrong", error.localizedDescription)
                return
            }
        }
    }
}
