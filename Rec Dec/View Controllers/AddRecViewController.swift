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

    var callerView : String? = nil
    
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
        performSegue(withIdentifier: "showDetailSegue", sender: searchDatabase.getShow(i: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var showToAdd = searchDatabase.getShow(i: indexPath.row)
        
        if callerView! == "HomeViewController" {
            let alert = UIAlertController(title: "Who recommended " + showToAdd.name + "?", message: "Leave blank to mark it as self-added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Type recommender here"
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let name = alert.textFields?.first?.text
                if name != "" {
                    showToAdd.recBy = name
                } else {
                    showToAdd.recBy = "Self-add"
                }
                self.performSegue(withIdentifier: "addNewRecSegue", sender: showToAdd)
            }))
            
            self.present(alert, animated: true)
        }
        if callerView! == "InboxViewController" {
            let alert = UIAlertController(title: "Who do you want to recommend " + showToAdd.name + " to?", message: "Please type in the recipient's username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Type recommender here"
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let name = alert.textFields?.first?.text
                if name == "" {
                    let alert = UIAlertController(title: "Error", message: "Recipient field can't be blank", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if !LoginViewController.users.contains(name!) {
                    let alert = UIAlertController(title: "Error", message: "Username doesn't exist", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    showToAdd.recBy = FirebaseController.fullname
                    FirebaseController.addShow(show: showToAdd, user: name!, toCollection: "inbox")

                    let alert = UIAlertController(title: "Sent!", message: "You recommended " + showToAdd.name + " to " + name! + "!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        self.performSegue(withIdentifier: "cancelSendSegue", sender: showToAdd)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    
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
        if callerView == "HomeViewController" {
            performSegue(withIdentifier: "cancelAddRecUnwindSegue", sender: self)
        }
        if callerView == "InboxViewController" {
            performSegue(withIdentifier: "cancelSendSegue", sender: self)
        }
    }
    
    @IBAction func backFromShowDescription(segue: UIStoryboardSegue) {  }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSegue" {
            let showToAdd = sender as! Show
            let dest = segue.destination as! ShowDataViewController
            dest.show = showToAdd
            dest.callerView = "AddRecViewController"
        }
        if segue.identifier == "addNewRecSegue" {
            let showToAdd = sender as! Show
            FirebaseController.addShow(show: showToAdd, user: FirebaseController.loggedIn, toCollection: "recs")
            let dest = segue.destination as! HomeViewController
            dest.recDatabase.addShow(show: showToAdd)
            dest.tableView.reloadData()
        }
    }

}
