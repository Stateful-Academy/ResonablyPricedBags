//
//  FirebaseAuthService.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation
import FirebaseAuth

/// Protocol we will use to create proper `Dependency Inversion` Used specially for User Account Creation
protocol FirebaseAuthServiceable {
    func createAccount(with email: String, password: String, handler: @escaping(Result<Bool, CreateAccountError>) -> Void)
    func signIn(with email: String, password: String, handler: @escaping(Result<Bool, CreateAccountError>) -> Void)
    func signOut()
}

struct FirebaseAuthService: FirebaseAuthServiceable {
    
    func createAccount(with email: String, password: String, handler: @escaping(Result<Bool, CreateAccountError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, fireBaseError in
            if let fireBaseError {
                handler(.failure(.firebaseError(fireBaseError)))
            }
            // No error - Could change to complete with a User if we needed
            handler(.success(true))
        }
    } // Create Account
    
    func signIn(with email: String, password: String, handler: @escaping(Result<Bool, CreateAccountError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                handler(.failure(.firebaseError(error)))
            }
            // No error - Could change to complete with a User if we needed
            handler(.success(true))
        }
    } // Sign in
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
    
} // Firebase Service
