//
//  TopTableViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 29/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {
    @IBOutlet weak var heading:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.heading.makeShadow()
    }


}
