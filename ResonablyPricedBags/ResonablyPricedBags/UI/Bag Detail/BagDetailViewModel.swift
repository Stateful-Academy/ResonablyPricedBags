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

protocol BagDetailViewModelDelegate: BagDetailViewController {
    func imageLoadedSuccessfully()
    func encountered(_ error: Error)
}

class BagDetailViewModel {
    
    var bag: Bag?
    var image: UIImage?
    weak var delegate: BagDetailViewModelDelegate?
    private var storageService: FirebaseStorageServiceable
    private var dbService: FirebaseDBServiceable
    
    init(bag: Bag?, injectedDelegate: BagDetailViewModelDelegate, storageService: FirebaseStorageServiceable = FirebaseStorageService(), dbService: FirebaseDBServiceable = FirebaseDBService()) {
        self.bag = bag
        self.delegate = injectedDelegate
        self.storageService = storageService
        self.dbService = dbService
        self.fetchImage(with: bag?.id)
    }
    
    func create(name: String, price: Double, season: String, origin: String, gender: String, handler: @escaping (Result<String,FirebaseError>) -> Void) {
        
        let sizeDict = Size(small: "is smol", medium: "mild?", large: "chonky")
        
        let colors = [Color(colorName: "blue"), Color(colorName: "Red")]
        
        let bag = Bag(name: name, price: price, season: season, originLocation: origin, gender: gender,  collectionType: Constants.Bags.bagsCollectionPath, size: sizeDict, colors: colors)
        
        dbService.createBag(bag: bag, handler: { [weak self] result in
            switch result {
            case .success(let docID):
                handler(.success(docID))
            case .failure(let failure):
                self?.delegate?.encountered(failure)
            }
        })
    }
    
    func saveImage(with image: UIImage, to docID: String) {
        
        // convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        storageService.saveImage(with: docID, from: imageData) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.imageLoadedSuccessfully()
            case .failure(let failure):
                self?.delegate?.encountered(failure)
            }
        }
    } // End of the save Image
    
    func fetchImage(with id: String?) {
        // where are we trying to fetch the image from?
        guard let id else {return}
        storageService.fetchImage(with: id) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
                self?.delegate?.imageLoadedSuccessfully()
            case .failure(let failure):
                self?.delegate?.encountered(failure)
            }
        }
    } // Fetch Image
    
    func updateBag(newName: String, newPrice: Double, newOrigin: String, newSeason: String, newGender: String) {
        guard let bagToUpdate = self.bag else {return}
        
        let updatedBag = Bag(id: bagToUpdate.id, name: newName, price: newPrice, season: newSeason, originLocation: newOrigin, gender: newGender, collectionType: Constants.Bags.bagsCollectionPath,size: bagToUpdate.size, colors: bagToUpdate.colors)// nil coalecing
        
        update(bag: updatedBag)
    }
    
    private func update(bag: Bag) {
        dbService.updateBag(bag: bag) { [weak self] result in
            switch result {
            case .success(_):
                print("Bag updated successfully")
            case .failure(let failure):
                self?.delegate?.encountered(failure)
            }
        }
    }
    
} // End of the class
