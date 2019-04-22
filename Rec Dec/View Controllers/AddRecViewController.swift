//
//  AddRecViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/16/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class AddRecViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var searchDatabase = MediaSearchDatabase.init()

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDatabase.numShows()
    }
    
    // thanks to Lucas Eduardo: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell")
        cell?.textLabel?.text = searchDatabase.getShow(i: indexPath.row).name
        cell?.detailTextLabel?.text = searchDatabase.getShow(i: indexPath.row).date?.prefix(4).description
        
        if let url = searchDatabase.getShow(i: indexPath.row).getImageURL() {
            cell?.imageView!.image = #imageLiteral(resourceName: "placeholderposter")  //Shows a placeholder that will stay there until image loads
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell?.imageView!.image = UIImage(data: data!)
                }
            }
        }
        else {
            cell?.imageView!.image = #imageLiteral(resourceName: "placeholderposter")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addNewRecSegue", sender: indexPath)
    }
    
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        return
//    }
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        if let term = searchBar.text {
            NetworkManager.networkRequestWithSearchTerm(term: term) { (shows) in
                self.searchDatabase.clearDatabase()
                for show in shows {
                    self.searchDatabase.addShow(show: show.show)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func didTapCancelAddRec(_ sender: Any) {
        searchDatabase.clearDatabase()
        performSegue(withIdentifier: "cancelAddRecUnwindSegue", sender: self)
    }
    
    @IBAction func backFromShowDescription(segue: UIStoryboardSegue) {  }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSegue" {
            let indexPath = sender as! IndexPath
            let selectedRow = indexPath.row
            let dest = segue.destination as! ShowDataViewController
            dest.show = searchDatabase.getShow(i: selectedRow)
        }
        if segue.identifier == "addNewRecSegue" {
            let indexPath = sender as! IndexPath
            let selectedRow = indexPath.row
            FirebaseController.addShow(newShow: searchDatabase.getShow(i: selectedRow))
        }
    }

}
