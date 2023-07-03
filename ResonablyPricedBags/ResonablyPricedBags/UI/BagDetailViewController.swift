//
//  BagDetailViewController.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/3/23.
//

import UIKit

class BagDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var bagNameTextField: UITextField!
    @IBOutlet weak var bagPriceTextField: UITextField!
    @IBOutlet weak var bagSeasonTextField: UITextField!
    @IBOutlet weak var bagOriginTextField: UITextField!
    @IBOutlet weak var bagGenderTextField: UITextField!
    @IBOutlet weak var saveBagButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: -  Actions
    @IBAction func addBagTapped(_ sender: Any) {
        
    }
    
  
} // End of the VC
