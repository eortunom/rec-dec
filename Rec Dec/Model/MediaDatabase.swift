//
//  MediaDatabase.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation

struct MediaDatabase {
    var shows = [Show]()
    
    func numShows() -> Int {
        return shows.count
    }
    
    mutating func addShow(show: Show) {
        shows.append(show)
    }
    
    mutating func clearDatabase() {
        shows = []
    }
    
    func getShow(i: Int) -> Show {
        return shows[i]
    }
    
}
