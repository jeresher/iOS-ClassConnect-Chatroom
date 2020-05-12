//
//  Users.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/13/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import Firebase

struct UserStruct {
    let uid: String
    let email: String
    var name: String
    var chatRooms = [String]()

    init(authData: User, name: String) {
        self.uid = authData.uid
        self.email = authData.email!
        self.name = name
    }
    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
    }
    init(authData: User) {
        
        self.uid = authData.uid
        self.email = authData.email!
        self.name = "Default"
    }
}
