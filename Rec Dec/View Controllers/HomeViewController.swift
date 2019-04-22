//
//  HomeViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/12/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var loggedIn = "eduardo"
    var recDatabase = MediaSearchDatabase.init()
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let shows = FirebaseController.fetchShows()
        for show in shows {
            print("adding")
            recDatabase.addShow(show: show)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recDatabase.numShows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell")
                cell?.textLabel?.text = recDatabase.getShow(i: indexPath.row).name
                cell?.detailTextLabel?.text = recDatabase.getShow(i: indexPath.row).date?.prefix(4).description
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
