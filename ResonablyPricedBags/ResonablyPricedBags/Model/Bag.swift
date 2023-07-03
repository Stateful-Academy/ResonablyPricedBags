//
//  Bag.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import Foundation

struct Bag {
   
    // Properties
    let name: String
    let price: Double
    let season: String
    let originLocation: String
    let gender: String
    let uuid: String = UUID().uuidString
    let collectionType: String = "Bags"
    
    // Setting the data - Writing
    var bagDictionaryReprentation: [String: AnyHashable] {
        ["name" : self.name,
         "price" : self.price,
         "season" : self.season,
         "origin" : self.originLocation,
         "gender" : self.gender,
         "collectionType" : self.collectionType,
         "uuid" : self.uuid]
    }
}
