//
//  User.swift
//  ToDoFire
//
//  Created by macbookp on 22.03.2021.
//

import Foundation
import Firebase

struct User {
    let uid : String
    let email : String
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
