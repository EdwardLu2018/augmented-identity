//
//  UserTableViewCell.swift
//  augmented-identity
//
//  Created by Edward on 4/3/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    var dict: NSDictionary?
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
