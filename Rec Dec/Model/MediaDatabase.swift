//
//  MediaDatabase.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation

struct MediaDatabase {
    static var shows : [Show] = []
    
    static func numShows() -> Int {
        return shows.count
    }
    
    static func addShow(show: Show) {
        shows.append(show)
    }
    
    static func clearDatabase() {
        shows = []
    }
    
    static func getShow(i: Int) -> Show {
        return shows[i]
    }
    
}
