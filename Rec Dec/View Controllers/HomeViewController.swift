//
//  HomeViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/12/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var recDatabase = MediaSearchDatabase.init()
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var db: Firestore! = Firestore.firestore()
    
    @IBAction func didTapLogOut(_ sender: Any) {
        performSegue(withIdentifier: "logOffSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        fetchShows()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchShows()
    }
    
    func fetchShows() {
        self.db.collection("users").document(FirebaseController.loggedIn).getDocument(source: FirestoreSource.default) { (document, error) in
            if let document = document {
                let dataDescription = document.data()
                self.recDatabase.clearDatabase()
                for element in dataDescription!["recs"]! as! [[String : String]] {
                    if element != [:] {
                        let date = (element["date"] == "none" ? nil : element["date"])
                        let summary = (element["summary"] == "none" ? nil : element["summary"])
                        let image = (element["image"] == "none" ? nil : element["image"])
                        self.recDatabase.addShow(show: Show.init(name: element["name"]!, date: date, image: Show.Image.init(url: image), summary: summary, recBy: element["recBy"]!))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recDatabase.numShows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: recDatabase.getShow(i: indexPath.row).name, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) in
            let show = self.recDatabase.getShow(i: indexPath.row)
            FirebaseController.removeShow(show: show, user: FirebaseController.loggedIn, fromCollection: "recs")
            self.recDatabase.removeShow(showToRemove: show)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: {tableView.deselectRow(at: indexPath, animated: true)});
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let show = recDatabase.getShow(i: indexPath.row)
        performSegue(withIdentifier: "detailFromHomeSegue", sender: show)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recCell")
        cell?.textLabel?.text = recDatabase.getShow(i: indexPath.row).name
        cell?.detailTextLabel?.text = recDatabase.getShow(i: indexPath.row).recBy
        
        if let url = recDatabase.getShow(i: indexPath.row).getImageURL() {
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
    
    @IBAction func cancelAddRec(segue: UIStoryboardSegue) {  }
    
    @IBAction func addNewRec(segue: UIStoryboardSegue) {  }
    
    @IBAction func showDataToHome(segue: UIStoryboardSegue) {  }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selfAddSegue" {
            let dest = segue.destination as! AddRecViewController
            dest.callerView = "HomeViewController"
        }
        if segue.identifier == "detailFromHomeSegue" {
            let show = sender as! Show
            let dest = segue.destination as! ShowDataViewController
            dest.show = show
            dest.callerView = "HomeViewController"
        }
        
    }
    
}
