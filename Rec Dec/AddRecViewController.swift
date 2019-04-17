//
//  AddRecViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/16/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class AddRecViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
