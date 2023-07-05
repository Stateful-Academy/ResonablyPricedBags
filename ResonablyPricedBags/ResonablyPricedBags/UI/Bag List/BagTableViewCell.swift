//
//  BagTableViewCell.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/4/23.
//

import UIKit

class BagTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bagNameLabel: UILabel!
    @IBOutlet weak var bagPriceLabel: UILabel!
    @IBOutlet weak var bagGenderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    
    
    // MARK: - Methods
    func configure(with bag: Bag?) {
        guard let bag else {return}
        bagNameLabel.text = bag.name
        bagPriceLabel.text = "\(bag.price)"
        bagGenderLabel.text = bag.gender
        originLabel.text = bag.originLocation
        seasonLabel.text = bag.season
    }
}
