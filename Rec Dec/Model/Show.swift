//
//  Show.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation

struct ShowWrapper: Codable {
    let show: [Show]
}

struct InnerShow : Codable {
    var name : String
    var year : String
    //var image : Image
    enum CodingKeys : String, CodingKey {
        case name
        case year = "premiered"
        //case image
    }
    //        struct Image : Codable {
    //            var url : String
    //            enum CodingKeys : String, CodingKey {
    //                case url = "original"
    //            }
    //        }
}

struct Image : Codable {
    let original : String
}

struct Show : Codable {
    //var name : String = ""
    //var network : String = ""
    //var imageUrl : String = ""
    //var innershow : InnerShow = InnerShow(name: "", year: "", image: [:])
    //var innershow : InnerShow = InnerShow(name: "", year: "", image: Image(original: ""))
    var innershow : InnerShow = InnerShow(name: "", year: "")
    enum CodingKeys : String, CodingKey {
        //case name = "trackName"
        //case network
        //case imageUrl = "artistName"
        case innershow = "show"
    }
    
//    init(name : String, artist : String, imageUrl : String) {
//        self.name = name
//        self.network = artist
//        self.imageUrl = imageUrl
//    }
    
//    func getImageURL() -> URL? {
//        let url = URL(string: innershow.image.url)
//        return url
//    }
    
    /*
     This method takes in Data optional (in this case, the JSON Data) and returns an array of objects of class Show.
     */
    static func dataToShows(_ data : Data?) -> [Show]? {
        guard let data = data else {
            print("Error: Nothing to decode")
            return nil
        }
        let decoder = JSONDecoder()
        guard let showWrapper = try? decoder.decode([Show].self, from: data) else {
            print(data)
            print("Error: Unable to decode songs data to Songs")
            return nil
        }
        print("Success")
        
        return showWrapper
    }
    
    
}
