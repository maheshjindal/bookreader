//
//  BookTableViewCell.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImageView:customImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var tableView:BookVC?
    var page:Page?{
        didSet{
            
            DispatchQueue.main.async {                setupBookImage(bookImageView: self.bookImageView,imageURL: self.page?.image,activityIndicator:self.activityIndicator,tableView:self.tableView)

            }
           
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
