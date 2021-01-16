//
//  ImageCollectionViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 28/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
     private let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var imageView: customImageView!
    @IBOutlet weak var imageLabel: UILabel!
    var comic:Comic?{
        didSet{
            imageLabel.text = comic?.title
            setupThumbnailImageToImageView(comicImageView: imageView, comic: comic)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),curveFactor:6)

    }
}
