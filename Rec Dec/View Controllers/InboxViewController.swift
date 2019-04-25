//
//  InboxViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/25/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var loggedIn = "eduardo"
    var recDatabase = MediaSearchDatabase.init()
    
    lazy var db: Firestore! = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        fetchShows()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchShows() {
        self.db.collection("users").document("eduardo").getDocument(source: FirestoreSource.default) { (document, error) in
            if let document = document {
                let dataDescription = document.data()
                for element in dataDescription!["inbox"]! as! [[String : String]] {
                    let date = (element["date"] == "none" ? nil : element["date"])
                    let summary = (element["summary"] == "none" ? nil : element["summary"])
                    let image = (element["image"] == "none" ? nil : element["image"])
                    self.recDatabase.addShow(show: Show.init(name: element["name"]!, date: date, image: Show.Image.init(url: image), summary: summary, recBy: element["recBy"]!))
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recDatabase.numShows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: recDatabase.getShow(i: indexPath.row).name, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Decline", style: .destructive, handler: {
            (alert: UIAlertAction!) in
            let show = self.recDatabase.getShow(i: indexPath.row)
            FirebaseController.removeShow(show: show)
            self.recDatabase.removeShow(showToRemove: show)
            self.tableView.reloadData()
        })
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: {
            (alert: UIAlertAction!) in
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(acceptAction)
        
        self.present(optionMenu, animated: true, completion: {tableView.deselectRow(at: indexPath, animated: true)});
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromInboxSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxRec")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailFromInboxSegue" {
            let indexPath = sender as! IndexPath
            let selectedRow = indexPath.row
            let dest = segue.destination as! ShowDataViewController
            dest.show = recDatabase.getShow(i: selectedRow)
            dest.callerView = "InboxViewController"
        }
    }
    
    @IBAction func showDescriptionToInbox(segue: UIStoryboardSegue) {  }


}
