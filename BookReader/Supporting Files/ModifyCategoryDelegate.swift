//
//  PassCategory.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 21/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation

protocol ModifyCategoryDelegate {
    func setCategory(categoryName : String)
}

protocol TransferComicsDelegate {
    func setComicsList(comicsList: [Comic])
}

protocol TransferComicDelegate {
    func setComic(comic: Comic)
}
protocol CheckItemsDelegate{
    func isItemAvailable(item:Bool)
}
protocol DataModelDelegate:class {
    func didRecieveUpdate(data:String)
}
