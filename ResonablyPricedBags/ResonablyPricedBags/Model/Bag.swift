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
    var name: String
    var price: Double
    var season: String
    var originLocation: String
    var gender: String
    var collectionType: String
    var size: Size // single dict
    var colors: [Color] // array of dict
}

//extension Bag: Equatable {
//    static func == (lhs: Bag, rhs: Bag) -> Bool {
//        return lhs._id == rhs._id
//    }
//}

struct Size: Codable {
    @DocumentID var id: String? // property Wrappe
    var small: String
    var medium: String
    var large: String
}

struct Color: Codable {
    var colorName: String
}
