//
//  ChatroomVC.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/14/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatroomVC: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    
    var userX: UserStruct!
    var chatroom: String!
    var messages: [MessageItem] = []
    
    let utilities = Utilities()
    let ref = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    let chatroomsRef = Database.database().reference(withPath: "chatrooms")

    
    @IBOutlet weak var chatroomTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Updates UserStruct with displayname.
        let userRef = Database.database().reference(withPath: "users").child(userX.uid)
        var FIRname: String?
        userRef.observe(.value, with: { snapshot in
            let dict = snapshot.value as! [String: AnyObject]
            FIRname = dict["name"] as? String
            self.userX.name = FIRname!
        })
       
        chatroomTitleLabel.text = chatroom
        chatroomsRef.child(chatroom).child("messages").observe(.value, with: { snapshot in
            var newMessages: [MessageItem] = []
            for message in snapshot.children {
                let messageItem = MessageItem(snapshot: message as! DataSnapshot)
                newMessages.append(messageItem)
            }
            self.messages = newMessages
            self.tableView.reloadData()
            self.moveToBottom()
        })
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
            self.moveToBottom()
        }
    }
    
    
    @IBAction func sendButtonDidtouch(_ sender: UIButton) {
        let text = messageTextField.text!
        // Firebase: Message.
        let comment = MessageItem(name: userX.name, message: text, postedDate: ServerValue.timestamp())
        let messagesRef = chatroomsRef.child(chatroom).child("messages")
        let specificMessageRef = messagesRef.childByAutoId()
        specificMessageRef.setValue(comment.toAnyObject())
        self.messageTextField.text = ""
        // Firebase: Message Preview.
        let latestRef = chatroomsRef.child(chatroom).child("latest")
        latestRef.setValue("\(userX.name): \(text)")
        // Firebase: Message Time Preview.
        let latestTimeRef = chatroomsRef.child(chatroom).child("latestTime")
        latestTimeRef.setValue(comment.postedDate)
        self.messageTextField.resignFirstResponder()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = "MessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath)
        
        let message = messages[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(5) as? UILabel {
            if message.name == userX.name {
                nameLabel.textColor = utilities.blueColor
                nameLabel.text = message.name
            } else {
                nameLabel.textColor = utilities.grayColor
                nameLabel.text = message.name
            }
        }
        
        if let commentLabel = cell.viewWithTag(10) as? UILabel {
            commentLabel.text = message.message
        }
        
        if let dateLabel = cell.viewWithTag(7) as? UILabel {
            dateLabel.text = utilities.convertTimestamp(message.postedDate!)
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func moveToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = messageTextField.text!
        // Firebase: Message.
        let comment = MessageItem(name: userX.name, message: text, postedDate: ServerValue.timestamp())
        let messagesRef = chatroomsRef.child(chatroom).child("messages")
        let specificMessageRef = messagesRef.childByAutoId()
        specificMessageRef.setValue(comment.toAnyObject())
        self.messageTextField.text = ""
        // Firebase: Message Preview.
        let latestRef = chatroomsRef.child(chatroom).child("latest")
        latestRef.setValue("\(userX.name): \(text)")
        // Firebase: Message Time Preview.
        let latestTimeRef = chatroomsRef.child(chatroom).child("latestTime")
        latestTimeRef.setValue(comment.postedDate)
        self.messageTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonDidTouch(_ sender: UIButton) {
        performSegue(withIdentifier: "chatToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatToMain" {
            let vc = segue.destination as? MainScreenVC
            vc?.userX = userX
        }
    }
    
}
