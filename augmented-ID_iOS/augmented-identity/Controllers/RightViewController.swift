//
//  RightViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import Firebase

class RightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var githubTextField: UITextField!
    @IBOutlet weak var linkedInTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var personalTextField: UITextField!
    @IBOutlet weak var skill1TextField: UITextField!
    @IBOutlet weak var skill2TextField: UITextField!
    @IBOutlet weak var skill3TextField: UITextField!
    @IBOutlet weak var skill4TextField: UITextField!
    @IBOutlet weak var skill5TextField: UITextField!
    
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.majorTextField.delegate = self
        self.githubTextField.delegate = self
        self.linkedInTextField.delegate = self
        self.facebookTextField.delegate = self
        self.personalTextField.delegate = self
        self.skill1TextField.delegate = self
        self.skill2TextField.delegate = self
        self.skill3TextField.delegate = self
        self.skill4TextField.delegate = self
        self.skill5TextField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.ref = Database.database().reference()
        self.ref.child("users").child(self.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.firstNameTextField.text = (value?["firstName"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.lastNameTextField.text = (value?["lastName"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.majorTextField.text = (value?["major"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.githubTextField.text = (value?["github"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.linkedInTextField.text = (value?["linkedIn"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.facebookTextField.text = (value?["facebook"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.personalTextField.text = (value?["personalSite"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.skill1TextField.text = (value?["skill1"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.skill2TextField.text = (value?["skill2"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.skill3TextField.text = (value?["skill3"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.skill4TextField.text = (value?["skill4"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
            self.skill5TextField.text = (value?["skill5"] as? String ?? "N/A").trimmingCharacters(in: .whitespaces)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.firstNameTextField.center.x  -= view.bounds.width
//        self.lastNameTextField.center.x  += view.bounds.width
//        self.majorTextField.center.x  -= view.bounds.width
//        self.githubTextField.center.x  -= view.bounds.width
//        self.linkedInTextField.center.x  += view.bounds.width
//        self.facebookTextField.center.x  -= view.bounds.width
//        self.personalTextField.center.x  += view.bounds.width
//        
//        UIView.animate(withDuration: 2) {
//            self.firstNameTextField.center.x += self.view.bounds.width
//            self.lastNameTextField.center.x -= self.view.bounds.width
//            self.majorTextField.center.x += self.view.bounds.width
//            self.githubTextField.center.x  += self.view.bounds.width
//            self.linkedInTextField.center.x  -= self.view.bounds.width
//            self.facebookTextField.center.x  += self.view.bounds.width
//            self.personalTextField.center.x  -= self.view.bounds.width
//        }
//    }
    
    @IBAction func firstNameEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/firstName").setValue(self.firstNameTextField.text)
    }
    
    @IBAction func lastNameEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/lastName").setValue(self.lastNameTextField.text)
    }
    
    @IBAction func majorEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/major").setValue(self.majorTextField.text)
    }
    
    @IBAction func githubEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/github").setValue(self.githubTextField.text)
    }
    
    @IBAction func linkedInEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/linkedIn").setValue(self.linkedInTextField.text)
    }
    
    @IBAction func facebookEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/facebook").setValue(self.facebookTextField.text)
    }
    
    @IBAction func personalEditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/personalSite").setValue(self.personalTextField.text)
    }
    
    @IBAction func skill1EditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/skill1").setValue(self.skill1TextField.text)
    }
    
    @IBAction func skill2EditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/skill2").setValue(self.skill2TextField.text)
    }
    
    @IBAction func skill3EditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/skill3").setValue(self.skill3TextField.text)
    }
    
    @IBAction func skill4EditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/skill4").setValue(self.skill4TextField.text)
    }
    
    @IBAction func skill5EditingChanged(_ sender: Any) {
        self.ref.child("users/\(self.userID!)/skill5").setValue(self.skill5TextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
}
