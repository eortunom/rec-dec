//
//  ViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/7/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        username.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        username.setLeftPaddingPoints(8)
        username.setRightPaddingPoints(8)
        password.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        password.setLeftPaddingPoints(8)
        password.setRightPaddingPoints(8)
    }
    
    
    @IBAction func cancelRegister(segue: UIStoryboardSegue) {  }
    
    @IBAction func logOff(segue: UIStoryboardSegue) {  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInSegue" {
            FirebaseController.loggedIn = username.text ?? "eduardo"
            FirebaseController.getFullName()
        }
    }


}

