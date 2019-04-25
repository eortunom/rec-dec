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
    
    static func addShow(newShow : Show) {
        var imageUrl = "none"
        if let image = newShow.getImageURL() {
            imageUrl = image.absoluteString
        }
        db.collection("users").document("eduardo").updateData([
            "recs": FieldValue.arrayUnion([["name" : newShow.name, "date" : newShow.date ?? "none", "image" : imageUrl, "summary" : newShow.summary ?? "none", "recBy" : newShow.recBy]])
            ])
    }
    
    static func removeShow(show : Show) {
        var imageUrl = "none"
        if let image = show.getImageURL() {
            imageUrl = image.absoluteString
        }
        db.collection("users").document("eduardo").updateData(["recs" : FieldValue.arrayRemove([["name" : show.name, "date" : show.date, "image" : imageUrl, "summary" : show.summary]])])
    }
}
