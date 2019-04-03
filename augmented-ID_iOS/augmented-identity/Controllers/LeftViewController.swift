//
//  LeftViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import Firebase

class LeftViewController: UIViewController {
    
    var users: [NSDictionary] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                for each in value {
                    let dict = each.1 as? NSDictionary
                    self.users.append(dict!)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
