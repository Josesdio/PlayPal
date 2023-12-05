//
//  LoginViewController.swift
//  PlayPalProject
//
//  Created by Josesdio on 29/10/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        guard let email = usernameTxt.text else { return }
        guard let password = passTxtField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("Error: \(e.localizedDescription)")
            } else {
                // Login successful, now check user data in Firestore or Firebase Database
                self.checkUserData(email: email)
            }
        }
    }
    
    func checkUserData(email: String) {
        // Perform a query to check if user data exists in Firestore or Firebase Database
        // For example, using Firestore:
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying user data: \(error.localizedDescription)")
            } else {
                if let document = querySnapshot?.documents.first {
                    // User data found, perform the necessary actions (e.g., segue to next screen)
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                } else {
                    print("User data not found.")
                }
            }
        }
    }
}



