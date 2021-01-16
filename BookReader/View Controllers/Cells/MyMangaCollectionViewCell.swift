//
//  MyMangaCollectionViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 23/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class MyMangaCollectionViewCell: UICollectionViewCell {
    var pagesToRead:Int!
    @IBOutlet weak var mangaImageView: customImageView!
    @IBOutlet weak var mangaComicAuthor: UILabel!
    @IBOutlet weak var mangaComicTitle: UILabel!
    @IBOutlet weak var mangaProgressView: UIProgressView!
    var currentComic:BookWithChapters?{
        didSet{
            setupThumbnailImageToImageView(comicImageView: mangaImageView, comic: currentComic?.comic)
            self.mangaComicAuthor.text = currentComic?.comic.author
            self.mangaComicTitle.text = currentComic?.comic.title
            mangaProgressView.progress = Float((currentComic?.readbook.chaptersReaded)!)/Float((currentComic?.comic.pages)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mangaImageView.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor: 20)
        self.mangaProgressView.addRadius()
    }
}
