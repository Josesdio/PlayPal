//
//  RegisterViewController.swift
//  PlayPalProject
//
//  Created by Josesdio on 29/10/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    var nameList = ["Play", "Pal"]
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func showError(message: String!) {
        let errorAlert = UIAlertController(title: "Error woi", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title:"Done", style: .default)
        errorAlert.addAction(ok)
        present(errorAlert, animated: true)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        guard let email = emailTxtField.text else { return }
        guard let password = passwordTxtField.text else { return }
        guard let username = usernameTxtField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error{
                print("error")
            }
            else{
                //back to home screen
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
            
            // Validasi email dengan regex
            let emailRegex = "^[a-zA-Z0-9_.+-]+@(gmail|yahoo)\\.com$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            if !emailPredicate.evaluate(with: email) {
                showError(message: "Email must be @gmail.com or @yahoo.com")
                return
            }
            
            // Validasi password harus alphanumeric
            let passwordRegex = "^[a-zA-Z0-9]+$"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            
            if !passwordPredicate.evaluate(with: password) {
                showError(message: "Password must be alphanumeric")
                return
            }
            
            // Validasi username harus memiliki setidaknya 6 karakter
            if username.count < 6 {
                showError(message: "Username must be at least 6 characters")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
                if let e = error {
                    print("Error: \(e.localizedDescription)")
                } else {
                    // User registered successfully
                    self.saveUserData(email: email, username: username)
                    // Proceed to home screen or performSegue
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            }
        }
        
        func saveUserData(email: String, username: String) {
            // Save user data to Firebase Firestore
            let db = Firestore.firestore()
            db.collection("users").document(email).setData(["username": username]) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User data saved successfully")
                }
            }
        }
    }
}
