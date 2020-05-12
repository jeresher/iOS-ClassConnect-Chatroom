//
//  AddChatroomVC.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/14/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddChatroomVC: UIViewController {
    
    var userX: UserStruct!
    
    let utilities = Utilities()
    let usersRef = Database.database().reference(withPath: "users")
    let chatroomsRef = Database.database().reference(withPath: "chatrooms")
    
    @IBOutlet weak var chatroomTextfield: UITextField!
    
    @IBAction func addButtonDidTouch(_ sender: UIButton) {
        
        if utilities.chatroomIDChecker(chatroomTextfield.text!){
            
            let chatroomName = chatroomTextfield.text!
            
            if userX.chatRooms.contains(chatroomName) {
                utilities.errorAlert(message: "You've already added this chatroom.", viewController: self)
                return
            }
            
            // This updates userX.chatRooms with the new chatroom.
            userX.chatRooms += [chatroomName]
            
            // This updates firebase with the new chatroom.
            usersRef.child(userX.uid).updateChildValues([
                "chatRooms": utilities.chatroomListToStringConverter(userX.chatRooms)
                ])
            let latestRef = chatroomsRef.child(chatroomName).child("latest")
            latestRef.setValue("")
            let latestTimeRef = chatroomsRef.child(chatroomName).child("latestTime")
            latestTimeRef.setValue(ServerValue.timestamp())
            performSegue(withIdentifier: "addToMain", sender: nil)
            
            
        } else {
            utilities.errorAlert(message: "Chatroom titles can only contain numbers, alphabets, and dashes.", viewController: self)
        }
    }
    
    
    @IBAction func backDidTouch(_ sender: UIButton) {
        performSegue(withIdentifier: "addToMain", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = userX
        }
    }

}
