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
            "recs": FieldValue.arrayUnion([["name" : newShow.name, "date" : newShow.date ?? "none", "image" : imageUrl, "summary" : newShow.summary ?? "none"]])
            ])
//
//        db.collection("users").document("eduardo").updateData([
//            "recs": FieldValue.arrayUnion([["name" : newShow.name, "date" : newShow.date ?? "none", "image" : newShow.getImageURL()?.absoluteString, "summary" : newShow.summary ?? "none"]])
//            ])
        
//        db.collection("users").whereField("username", isEqualTo: "eduardo")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//        }
        //db.collection("users").addDocument(data: ["name" : newShow.name])
    }
    
    static func fetchShows() -> [Show] {
        var output = [Show]()
        db.collection("users").document("eduardo").getDocument(source: FirestoreSource.default) { (document, error) in
            if let document = document {
                let dataDescription = document.data()
                for element in dataDescription!["recs"]! as! [[String : String]] {
                    let date = (element["date"] == "none" ? nil : element["date"])
                    let summary = (element["summary"] == "none" ? nil : element["summary"])
                    let image = (element["image"] == "none" ? nil : element["image"])
                    output.append(Show.init(name: element["name"]!, date: date, image: Show.Image.init(url: image), summary: summary))
                }
            }
        }
        return output
    }
}
