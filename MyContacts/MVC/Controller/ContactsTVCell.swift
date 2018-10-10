//
//  ContactsTVCell.swift
//  MyContacts
//
//  Created by Laxmikanth Reddy on 08/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import UIKit

class ContactsTVCell: UITableViewCell {
    @IBOutlet weak var contactImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var mobNumLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
