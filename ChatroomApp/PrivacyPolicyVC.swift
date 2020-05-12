//
//  PrivacyPolicyVC.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/13/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var privacyPolicyButtonOutlet: UIButton!
    
    
    @IBAction func privacyPolicyButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        if privacyPolicyButtonOutlet.isSelected {
            performSegue(withIdentifier: "privacyToSignUp", sender: nil)
        }
        if !privacyPolicyButtonOutlet.isSelected {
            performSegue(withIdentifier: "privacyToStarting", sender: nil)
        }
    }
    
}
