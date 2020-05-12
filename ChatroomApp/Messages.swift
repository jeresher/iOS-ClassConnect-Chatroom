//
//  Messages.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/14/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import Firebase

struct MessageItem {
    let ref: DatabaseReference?
    let name: String
    let message: String
    let postedDate: Any!
    init(name: String, message: String, postedDate: [AnyHashable: Any]) {
        self.name = name
        self.message = message
        self.postedDate = postedDate
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        message = (snapshotValue["message"] as? String)!
        name = (snapshotValue["name"] as? String)!
        postedDate = snapshotValue["postedDate"]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "message": message,
            "postedDate": postedDate
        ]
    }
}
