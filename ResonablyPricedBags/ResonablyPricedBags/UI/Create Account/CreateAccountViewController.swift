//
//  CreateAccountViewController.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import UIKit

class CreateAccountViewController: UIViewController, AlertPresentable {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var viewModel: CreateAccountViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CreateAccountViewModel(delegate: self)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {return}
        viewModel.createAccount(with: email, password: password, confirmPassword: confirmPassword)
       
    } // Create
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {return}
        viewModel.signIn(with: email, password: password, confirmPassword: confirmPassword)
    } // Sign in
    
} // VC

extension CreateAccountViewController: CreateAccountViewModelDelegate {
    func encountered(_ error: Error) {
        presentAlert(message: error.localizedDescription, title: " Oh no!")
    }
}
