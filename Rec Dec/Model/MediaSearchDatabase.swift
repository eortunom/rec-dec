//
//  MediaDatabase.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import Foundation

struct MediaSearchDatabase {
    private var shows : [Show] = []
    
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
    
    mutating func removeShow(showToRemove: Show) {
        if let index = shows.firstIndex(where: {$0.name == showToRemove.name}) {
            shows.remove(at: index)
        }
    }
    
}
