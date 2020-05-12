//
//  SignUpVC.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/13/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    var userX: UserStruct!
    var displayName: String?
    
    let utilities = Utilities()
    let ref = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpDidTouch(_ sender: UIButton) {
        if let name = displayNameField.text, let email = emailField.text, let password = passwordField.text {
            if passwordField.text == confirmPasswordField.text {
                if utilities.displayNameChecker(name) {
                    Auth.auth().createUser(withEmail: email, password: password) { user, error in
                        if error != nil {
                            self.utilities.errorAlert(message: error!.localizedDescription, viewController: self)
                            return
                        }
                        // Firebase setup.
                        guard let uid = user?.uid else { return }
                        Auth.auth().signIn(withEmail: email, password: password)
                        let userValues = ["name": name, "email": email, "chatRooms": ""]
                        let userRef = self.usersRef.child(uid)
                        userRef.setValue(userValues)
                        // Client-Side setup.
                        self.userX = UserStruct(authData: user!, name: name)
                        // Segue.
                        self.performSegue(withIdentifier: "signUpToMain", sender: self.userX)
                    }
                } else {
                    self.utilities.errorAlert(message: "Display name may not contain special characters, spaces, offensive language, and must be less than 20 characters.", viewController: self)
                }
            } else {
                self.utilities.errorAlert(message: "Your password and confirmation password do not match.", viewController: self)
            }
        } else {
            self.utilities.errorAlert(message: "", viewController: self)
        }
    }
    
    
    // Transfers userX from SignUpVC -> MainScreenVC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = sender as? UserStruct
        }
    }
    
}
