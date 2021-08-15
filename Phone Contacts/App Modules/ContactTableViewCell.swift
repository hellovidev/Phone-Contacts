//
//  ContactTableViewCell.swift
//  Phone Contacts
//
//  Created by Sergei Romanchuk on 15.08.2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactFullName: UILabel!
    @IBOutlet weak var contactPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
