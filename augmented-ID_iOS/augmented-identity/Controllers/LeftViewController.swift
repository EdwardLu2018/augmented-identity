//
//  LeftViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import Firebase

struct CellData {
    let name: String?
    let dict: NSDictionary?
}

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var data: [CellData] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                for each in value {
                    let dict = each.1 as? NSDictionary
                    guard let firstName = dict?["firstName"] as? String else { return }
                    guard let lastName = dict?["lastName"] as? String else { return }
                    let fullName = firstName + " " + lastName
                    self.data.append(CellData.init(name: fullName, dict: dict))
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        cell.nameLabel.text = data[indexPath.row].name
        cell.dict = self.data[indexPath.row].dict
        return cell
    }
}
