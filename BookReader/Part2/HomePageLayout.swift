//
//  HomePageLayout.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 22/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation
import UIKit

class HomeSection{
    var name:String!
    var comicsList:[Comic]!
    init(name:String, comicList:[Comic]) {
        self.name = name
        self.comicsList = comicList
    }
    convenience init(name:String){
        self.init(name: name, comicList: [])
    }
    func addElement(comic:Comic){
        self.comicsList.append(comic)
    }
    func getComicsCount() -> Int{
        return self.comicsList.count
    }
}
