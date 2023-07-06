//
//  CreateAccountViewModel.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation

struct CreateAccountViewModel {
    
    func createAccount(with email: String, password: String, confirmPassword: String) {
        
        FirebaseService().createAccount(with: email, password: password, confirmPassword: confirmPassword)
    } // Create Account
    
    func signIn(with email: String, password: String, confirmPassword: String) {
        
        if password == confirmPassword {
            FirebaseService().signIn(email: email, password: password)
        }
    } // Sign in
    
} // View Model
