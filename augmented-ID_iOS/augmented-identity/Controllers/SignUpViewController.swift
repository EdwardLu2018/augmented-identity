//
//  SignUpViewController.swift
//  augmented-identity
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    @IBOutlet weak var confirmation: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func signUpAction(_ sender: Any) {
        if password.text != confirmation.text {
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "Please re-type password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
