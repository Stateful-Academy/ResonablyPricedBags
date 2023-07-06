//
//  FirebaseService.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/6/23.
//

import Foundation
import FirebaseAuth

struct FirebaseService {
    
    func createAccount(with email: String, password: String, confirmPassword: String) {
        // I only want to create a user if the passwords match
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                print(authResult?.user.email!)
            }
        } else {
            #warning("Update to present an alert to the user")
        }
    } // Create Account
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                // basic error handling
                #warning("Update to present an alert to the user")
            }
            
            print(authResult?.user.email!)
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
