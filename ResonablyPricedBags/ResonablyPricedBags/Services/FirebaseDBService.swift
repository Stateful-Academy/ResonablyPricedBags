//
//  FirebaseDBService.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Protocol we will use to create proper `Dependency Inversion` Used specially for accesing Firestore DB
protocol FirebaseDBServiceable {
    func fetchAllBags(handler: @escaping(Result<[Bag], FirebaseError>) -> Void)
    func updateBag(bag: Bag, handler: @escaping(Result<Bool, FirebaseError>) -> Void)
    func createBag(bag: Bag, handler: @escaping(Result<String, FirebaseError>) -> Void)
    func deleteBag(bag: Bag, handler: @escaping(Result<Bool, FirebaseError>) -> Void)
}

struct FirebaseDBService: FirebaseDBServiceable {
    let dbRef = Firestore.firestore().collection(Constants.Bags.bagsCollectionPath)
    
    func fetchAllBags(handler: @escaping (Result<[Bag], FirebaseError>) -> Void) {
        dbRef.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            do {
                let bagsArray = try documents.compactMap({ try $0.data(as: Bag.self)})
                handler(.success(bagsArray))
            } catch {
                handler(.failure(.firebaseError(error)))
            }
        }
    }
    
    func deleteBag(bag: Bag, handler: @escaping (Result<Bool, FirebaseError>) -> Void) {
        dbRef.document(bag.id!).delete { error in
            if let error {
                handler(.failure(.firebaseError(error)))
            }
            // No error; successful
            handler(.success(true))
        }
    }
    
    func updateBag(bag: Bag, handler: @escaping (Result<Bool, FirebaseError>) -> Void) {
        if let documentID = bag.id {
            let docref = dbRef.document(documentID)
            do {
                try docref.setData(from: bag)
                handler(.success(true))
            } catch {
                handler(.failure(.firebaseError(error)))
            }
        }
    } // Update
    
    func createBag(bag: Bag, handler: @escaping (Result<String, FirebaseError>) -> Void) {
        do {
            let documentRef = try dbRef.addDocument(from: bag, completion: { error in
                if let error {
                    handler(.failure(.firebaseError(error)))
                }
            })
            // No error; successful
            handler(.success(documentRef.documentID))
        } catch {
            handler(.failure(.firebaseError(error)))
        }
    } // Create
    
} // Firebase Service
