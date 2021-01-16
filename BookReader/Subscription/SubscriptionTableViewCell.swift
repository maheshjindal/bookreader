//
//  SubscriptionTableViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 12/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var subscriptionTitle:UILabel!
    @IBOutlet weak var subscriptionAmount:UILabel!
    @IBOutlet weak var subscriptionDescription:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
