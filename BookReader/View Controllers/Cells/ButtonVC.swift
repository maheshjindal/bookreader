//
//  ButtonVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 21/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class ButtonVC: UICollectionViewCell {
    @IBOutlet weak var btnLabel:UILabel!
    
    var category:Category?{
        didSet{
            btnLabel.text = category?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
