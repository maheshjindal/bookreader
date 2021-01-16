//
//  CategoryListCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 22/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    
    
    @IBOutlet weak var comicTitle:UILabel!
    @IBOutlet weak var comicImageView:customImageView!
    @IBOutlet weak var authorName:UILabel!
    @IBOutlet weak var comicDescription:UILabel!
    var comic:Comic?{
        didSet{
            comicTitle.text = comic?.title
            setupThumbnailImageToImageView(comicImageView: comicImageView, comic: comic)
            authorName.text = comic?.author
            comicDescription.text = comic?.description
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        comicImageView.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor: 6)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}


