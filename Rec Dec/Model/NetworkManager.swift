//
//  NetworkManager.swift
//
//

import Foundation

class NetworkManager {
    
    static func networkRequestWithSearchTerm(term: String, completion: @escaping ([ShowInnerWrapper]) -> Void) {
        let query = term.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "http://api.tvmaze.com/search/shows?q=\(query)")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, status == 200 else {
                print("Not 200 response code")
                return
            }
            if let shows = ShowInnerWrapper.dataToShows(data) {
                completion(shows)
            } else {
                print("Error")
            }
        }
        task.resume()
        
    }
    
}
