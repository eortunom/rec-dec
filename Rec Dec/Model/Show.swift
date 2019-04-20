//
//  Show.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation

struct ShowOuterWrapper: Codable {
    let show: [ShowInnerWrapper]
}

struct ShowInnerWrapper : Codable {
    
    var show : Show
    enum CodingKeys : String, CodingKey {
        case show
    }
    
    /*
     This method takes in Data optional (in this case, the JSON Data) and returns an array of objects of class Show.
     */
    static func dataToShows(_ data : Data?) -> [ShowInnerWrapper]? {
        guard let data = data else {
            print("Error: Nothing to decode")
            return nil
        }
        let decoder = JSONDecoder()
        guard let showOuterWrapper = try? decoder.decode([ShowInnerWrapper].self, from: data) else {
            print(data)
            print("Error: Unable to decode songs data to Songs")
            return nil
        }
        print("Success")
        
        return showOuterWrapper
    }
}

struct Show : Codable {
    let name : String
    let date : String?
    let image : Image?
    let summary : String?
    
    enum CodingKeys : String, CodingKey {
        case name
        case date = "premiered"
        case image
        case summary
    }
    
    struct Image : Codable {
        var url : String
        enum CodingKeys : String, CodingKey {
            case url = "original"
        }
    }
    
    func getImageURL() -> URL? {
        let url = URL(string: image?.url ?? "")
        return url
    }
}
