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
    @IBOutlet weak var bagDisplayImageVIew: UIImageView!
    
    // Property
    var viewModel: BagDetailViewModel! // implecently unwrapping
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        configureView()
    }
    
    
    // MARK: - Methods
    private func configureView() {
        guard let bag = viewModel.bag else {return}
        bagNameTextField.text = bag.name
        bagPriceTextField.text = "\(bag.price)"
        bagSeasonTextField.text = bag.season
        bagOriginTextField.text = bag.originLocation
        bagGenderTextField.text = bag.gender
        // TODO: - how to image?
        
        
    }
    private func setUpImageView () {
        bagDisplayImageVIew.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        bagDisplayImageVIew.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
        // Present the image picker to the user
        present(imagePicker, animated: true)
    }
    
    // MARK: -  Actions
    @IBAction func addBagTapped(_ sender: Any) {
        
        // Reading
        guard let name = bagNameTextField.text,
        let price = bagPriceTextField.text,
        let season = bagSeasonTextField.text,
        let origin = bagOriginTextField.text,
        let gender = bagGenderTextField.text,
        let image = bagDisplayImageVIew.image else {return}
        // Nil-Coalecing to unwrap the double
        let priceAsDouble = Double(price) ?? 0.0
        // Display
        viewModel.create(name: name, price: priceAsDouble, season: season, origin: origin, gender: gender) { result in
            switch result {
            case .success(let docId):
                self.viewModel.saveImage(with: image, to: docId)
            case .failure(let failure):
                print(failure.errorDescription!)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
} // End of the VC

extension BagDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Once the user is done choosing thier image.. I want to
        // Now that the view is dismissed I need to image to be set to the imageView
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        bagDisplayImageVIew.image = image
        picker.dismiss(animated: true)
    }
}
