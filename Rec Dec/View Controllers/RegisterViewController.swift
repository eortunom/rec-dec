//
//  RegisterViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/17/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameField.setLeftPaddingPoints(8)
        fullNameField.setRightPaddingPoints(8)
        usernameField.setLeftPaddingPoints(8)
        usernameField.setRightPaddingPoints(8)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapBackButton(_ sender: Any) {
        performSegue(withIdentifier: "cancelRegisterUnwindSegue", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "didRegisterSegue" {
            FirebaseController.logIn(username: usernameField.text!)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "didRegisterSegue" {
            if LoginViewController.users.contains(usernameField.text!) {
                let alert = UIAlertController(title: "Alert", message: "Username already exists", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            if usernameField.text == nil || usernameField.text == "" || fullNameField == nil ||
                fullNameField.text == "" {
                let alert = UIAlertController(title: "Alert", message: "No fields can be blank", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        FirebaseController.newUser(username: usernameField.text!, fullName: fullNameField.text!)
        return true
    }
    

}
