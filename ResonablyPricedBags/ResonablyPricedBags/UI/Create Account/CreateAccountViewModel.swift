//
//  CreateAccountViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation

protocol CreateAccountViewModelDelegate: CreateAccountViewController {
    func encountered(_ error: Error)
}
struct CreateAccountViewModel {
    
    // Properties
    private let service: FirebaseAuthServiceable
    weak var delegate: CreateAccountViewModelDelegate?
    
    // Dependency Injection
    init(service: FirebaseAuthServiceable = FirebaseAuthService(), delegate: CreateAccountViewModelDelegate) {
        self.service = service
        self.delegate = delegate
    }
    
    func createAccount(with email: String, password: String, confirmPassword: String) {
        if password == confirmPassword {
            service.createAccount(with: email, password: password) { result in
                switch result {
                case .success(_): // using _ because I don't have a reason to use the bool at this time
                    print("User was created successfuly!")
                case .failure(let failure):
                    delegate?.encountered(failure)
                }
            }
        } else {
            delegate?.encountered(CreateAccountError.passwordMismatch)
        }
    } // Create Account
    
    func signIn(with email: String, password: String, confirmPassword: String) {
        
        if password == confirmPassword {
            service.signIn(with: email, password: password) { result in
                switch result {
                case .success(_): // using _ because I don't have a reason to use the bool at this time
                    print("User was created successfuly!")
                case .failure(let failure):
                    delegate?.encountered(failure)
                }
            }
        }
        delegate?.encountered(CreateAccountError.passwordMismatch)
    } // Sign in
    
} // View Model
