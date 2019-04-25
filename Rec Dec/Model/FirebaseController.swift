//
//  FirebaseController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/20/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseController {
    static var db: Firestore! = Firestore.firestore()
    
    static func addShow(show : Show, user : String, toCollection : String) {
        var imageUrl = "none"
        if let image = show.getImageURL() {
            imageUrl = image.absoluteString
        }
        db.collection("users").document(user).updateData([
            toCollection: FieldValue.arrayUnion([["name" : show.name, "date" : show.date ?? "none", "image" : imageUrl, "summary" : show.summary ?? "none", "recBy" : show.recBy]])
            ])
    }
    
    static func removeShow(show : Show, user : String, fromCollection : String) {
        var imageUrl = "none"
        if let image = show.getImageURL() {
            imageUrl = image.absoluteString
        }
        db.collection("users").document(user).updateData([fromCollection : FieldValue.arrayRemove([["name" : show.name, "date" : show.date ?? "none", "image" : imageUrl, "summary" : show.summary ?? "none", "recBy" : show.recBy]])])
    }
    
    static func acceptRec(show : Show, user : String) {
        removeShow(show: show, user: user, fromCollection: "inbox")
        addShow(show: show, user: user, toCollection: "recs")
    }
}
