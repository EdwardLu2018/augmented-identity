//
//  LeftViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import Firebase

class LeftViewController: UITableViewController {
    
    var data: [CellData] = []
    var ref: DatabaseReference!
    @IBOutlet weak var refresh: UIRefreshControl!
    
    struct CellData {
        let name: String?
        let dict: NSDictionary?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        refreshUsers()
        
        self.refresh.addTarget(self, action: #selector(refreshUserData(_:)), for: .valueChanged)
        self.refresh.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        cell.nameLabel.text = data[indexPath.row].name
        cell.dict = self.data[indexPath.row].dict
        return cell
    }
    
    @objc func refreshUserData(_ sender: Any) {
        refreshUsers()
    }
    
    func refreshUsers() {
        self.data = []
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                for each in value {
                    let dict = each.1 as? NSDictionary
                    guard let firstName = dict?["firstName"] as? String else { break }
                    guard let lastName = dict?["lastName"] as? String else { break }
                    let fullName = firstName + " " + lastName
                    self.data.append(CellData.init(name: fullName, dict: dict))
                    self.tableView.reloadData()
                }
                self.refresh.endRefreshing()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
