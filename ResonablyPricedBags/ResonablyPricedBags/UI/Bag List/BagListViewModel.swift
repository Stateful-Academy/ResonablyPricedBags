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
    func encountered(_ error: Error)
}

class BagListViewModel {
    
    var bagsSourceOfTruth: [Bag]?
    // create the position. This is their employee number when we hire them
    private let service: FirebaseDBServiceable
    weak var delegate: BagListViewModelDelegate?
    
    // DEPENDENCY INJECTION - why? To make our code easier to test.
    init(injectedDelegate: BagListViewModelDelegate, service: FirebaseDBServiceable = FirebaseDBService()) {
        self.delegate = injectedDelegate // Hiring the person
        self.service = service
    }
    // Fetch all the bags
    func fetchAllBags() {
        service.fetchAllBags { [weak self] result in
            switch result {
            case .success(let fetchedBags):
                self?.bagsSourceOfTruth = fetchedBags
                self?.delegate?.successfullyLoadedData()
            case .failure(let error):
                self?.delegate?.encountered(error)
            }
        }
    } // Fetch
    
    func delete(indexPath: IndexPath, callback:@escaping () -> Void) {
        guard let bag = bagsSourceOfTruth?[indexPath.row] else {return}
        service.deleteBag(bag: bag) { [weak self] result in
            switch result {
            case .success(_):
                // Not really doing anything but removing the data from the SOT
                self?.bagsSourceOfTruth?.remove(at: indexPath.row)
                callback()
            case .failure(let failure):
                self?.delegate?.encountered(failure)
            }
        }
    } // Delete
    
} // Class
