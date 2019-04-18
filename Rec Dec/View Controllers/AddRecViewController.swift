//
//  AddRecViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/16/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class AddRecViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        database = MediaDatabase()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var database: MediaDatabase!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.numShows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell")
        cell?.textLabel?.text = database.getShow(i: indexPath.row).innershow.name
        // cell?.imageView?.image = 
        //cell?.detailTextLabel?.text = database.getShow(i: indexPath.row).innershow.network.networkName
        cell?.detailTextLabel?.text = database.getShow(i: indexPath.row).innershow.year.prefix(4).description
        cell?.imageView?.image = #imageLiteral(resourceName: "blackmirror")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        if let term = searchBar.text {
            NetworkManager.networkRequestWithSearchTerm(term: term) { (shows) in
                self.database.clearDatabase()
                for show in shows {
                    self.database.addShow(show: show)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func didTapCancelAddRec(_ sender: Any) {
        performSegue(withIdentifier: "cancelAddRecUnwindSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
