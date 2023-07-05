//
//  BagListViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/4/23.
//

import Foundation
import FirebaseFirestore

// Creating a job req
protocol BagListViewModelDelegate: BagListTableViewController {
    func successfullyLoadedData()
}

class BagListViewModel {
    
    var bagsSourceOfTruth: [Bag]?
    // create the position. This is their employee number when we hire them
    weak var delegate: BagListViewModelDelegate?
    
    // DEPENDENCY INJECTION - why? To make our code easier to test.
    init(injectedDelegate: BagListViewModelDelegate) {
        self.delegate = injectedDelegate // Hiring the person
        fetchAllBags()
    }
    // Fetch all the bags
    func fetchAllBags() {
        let db = Firestore.firestore()
        db.collection(Constants.Bags.bagsCollectionPath).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            do {
                let bagsArray = try documents.compactMap({ try $0.data(as: Bag.self)})
                self.bagsSourceOfTruth = bagsArray
                self.delegate?.successfullyLoadedData()
                print(bagsArray)
            } catch {
                print("oh no!", error.localizedDescription)
            }
        }
    }
}
