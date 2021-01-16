//
//  HeadingTableViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 29/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class HeadingTableViewCell: UITableViewCell {
    @IBOutlet weak var heading:UILabel!
    @IBAction func moreButton(_ sender: Any) {
   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.heading.makeShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
