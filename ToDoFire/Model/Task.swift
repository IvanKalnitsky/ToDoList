//
//  Task.swift
//  ToDoFire
//
//  Created by macbookp on 22.03.2021.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    init(snapShot: DataSnapshot) {
        let snapshotValue = snapShot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapShot.ref
    }
    
    func convertToDictionary() -> Any {
        return [ "title":title,"userId":userId, "completed": completed]
    }
}


