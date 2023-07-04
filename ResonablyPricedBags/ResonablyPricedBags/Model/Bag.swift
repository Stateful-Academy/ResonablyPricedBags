//
//  Bag.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Bag: Codable {
   
    // Properties
    @DocumentID var id: String? // property Wrapper
    let name: String
    let price: Double
    let season: String
    let originLocation: String
    let gender: String
    let collectionType: String
    let size: Size // single dict
    let colors: [Color] // array of dict
}

struct Size: Codable {
    var small: String
    var medium: String
    var large: String
}

struct Color: Codable {
    var colorName: String
}
