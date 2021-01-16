//
//  Category.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation
class Category {
    var title:String!
    var image:String!
    var query_url:String!
    var track_url:String!
    
    init(title:String, image:String, query_url:String, track_url:String ) {
        self.title = title
        self.image = image
        self.query_url = query_url
        self.track_url = track_url
    }
  
}
