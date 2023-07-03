//
//  BagDetailViewController.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import UIKit
import FirebaseFirestore

class BagDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var bagNameTextField: UITextField!
    @IBOutlet weak var bagPriceTextField: UITextField!
    @IBOutlet weak var bagSeasonTextField: UITextField!
    @IBOutlet weak var bagOriginTextField: UITextField!
    @IBOutlet weak var bagGenderTextField: UITextField!
    @IBOutlet weak var saveBagButton: UIButton!
    
    // Property
    var viewModel: BagDetailViewModel! // implecently unwrapping
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BagDetailViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: -  Actions
    @IBAction func addBagTapped(_ sender: Any) {
        
        // Reading
        guard let name = bagNameTextField.text,
        let price = bagPriceTextField.text,
        let season = bagSeasonTextField.text,
        let origin = bagOriginTextField.text,
        let gender = bagGenderTextField.text else {return}
        // Nil-Coalecing to unwrap the double
        let priceAsDouble = Double(price) ?? 0.0
        // Display
        viewModel.create(name: name, price: priceAsDouble, season: season, origin: origin, gender: gender)
    }
    
} // End of the VC
