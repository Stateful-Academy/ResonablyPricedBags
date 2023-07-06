//
//  FirebaseError.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/5/23.
//

import Foundation
enum FirebaseError: LocalizedError {
    case firebaseError(Error)
    case failedToUnwrapData
    case noDataFound
    case invalidURL
    case badImage

    var errorDescription: String? {
        switch self {
        case .firebaseError(let error):
            return "\(error.localizedDescription)"
        case .failedToUnwrapData:
            return "failed unwrap"
        case .noDataFound:
            return "noData"
        case .invalidURL:
            return "url"
        case .badImage:
            return "bad image"
        }
    }
}
