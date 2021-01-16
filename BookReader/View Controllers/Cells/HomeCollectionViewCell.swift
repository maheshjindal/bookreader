//
//  HomeCollectionViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 29/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    private let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var imageView: customImageView!
    @IBOutlet weak var imageLabel: UILabel!

    @IBOutlet weak var cellactivity: UIActivityIndicatorView!
    
    var comic:Comic?{
        
        didSet{
            imageLabel.text = comic?.title
            setupThumbnailImageToImageView(comicImageView: imageView, comic: comic)
            
        }
    }
    var category:Category?{
        didSet{
            imageLabel.text = category?.title
            imageView.setupThumbnailImageFromURL(imageURL: category?.image)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor:6)

    }
    
}
