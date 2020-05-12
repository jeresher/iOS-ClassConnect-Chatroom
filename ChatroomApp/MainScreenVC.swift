//
//  MainScreenVC.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/13/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userX: UserStruct!
    var chatRooms: [String] = []
    
    let utilities = Utilities()
    let ref = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    let chatroomsRef = Database.database().reference(withPath: "chatrooms")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        // This observer checks user's saved chatrooms on Firebase and updates tableView.
        usersRef.child(userX.uid).observe(.value, with: { snapshot in
            var newChatrooms: [String] = []
            
            let allSnapshotValues = snapshot.value as? NSDictionary
            let chatroomSnapshotValues = allSnapshotValues!["chatRooms"] as? String
            
            newChatrooms = self.utilities.chatroomStringToListConverter(chatroomSnapshotValues!)
            
            self.chatRooms = newChatrooms
            
            self.userX.chatRooms = newChatrooms
            
            self.tableView.reloadData()
        })
        
        
    }
    
    @IBAction func addChatroomButtonDidTouch(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToAdd", sender: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ChatroomCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let chatRoom = chatRooms[indexPath.row]
        
        
        self.chatroomsRef.child(chatRoom).observeSingleEvent(of: .value, with: { snapshot in
            let dict = snapshot.value as! [String: AnyObject]
            let messagePreview = dict["latest"] as! String
            let messageTime = dict["latestTime"]
            if let messagePreviewLabel = cell.viewWithTag(15) as? UILabel {
                messagePreviewLabel.text = messagePreview
            }
            
            if let messageTimeLabel = cell.viewWithTag(20) as? UILabel {
                messageTimeLabel.text = self.utilities.convertTimestamp(messageTime!)
            }
        })
        
        
        if let chatroomLabel = cell.viewWithTag(10) as? UILabel {
            chatroomLabel.text = chatRoom
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroom = chatRooms[indexPath.row]
        
        userXandChatroom = [userX, chatroom]
        
        performSegue(withIdentifier: "mainToChat", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userX.chatRooms.remove(at: indexPath.row)
            usersRef.child(userX.uid).updateChildValues([
                "chatRooms": utilities.chatroomListToStringConverter(userX.chatRooms)
                ])
            
            tableView.reloadData()
        }
    }
    
    var userXandChatroom = Array<Any>()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAdd" {
            let vc = segue.destination as? AddChatroomVC
            vc?.userX = self.userX
        }
        if segue.identifier == "mainToChat" {
            let vc = segue.destination as? ChatroomVC
            vc?.userX = userXandChatroom[0] as! UserStruct
            vc?.chatroom = userXandChatroom[1] as! String
        }
        if segue.identifier == "mainToStarting" {
            
        }
    }
}
