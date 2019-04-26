//
//  RegisterViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNameField.setLeftPaddingPoints(8)
        displayNameField.setRightPaddingPoints(8)
        usernameField.setLeftPaddingPoints(8)
        usernameField.setRightPaddingPoints(8)
        passwordField.setLeftPaddingPoints(8)
        passwordField.setRightPaddingPoints(8)
        confirmPasswordField.setLeftPaddingPoints(8)
        confirmPasswordField.setRightPaddingPoints(8)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapBackButton(_ sender: Any) {
        performSegue(withIdentifier: "cancelRegisterUnwindSegue", sender: self)
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
