//
//  Receipt.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 12/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import Foundation

class Receipt{
    var purchase_date:Date!
    var expire_date:Date!
    var product_id:String!
    var transactionId:String!
    
    init(purchaseDate:Date,expireDate:Date,productId:String,transactionId:String) {
        self.product_id = productId
        self.purchase_date = purchaseDate
        self.expire_date = expireDate
        self.transactionId = transactionId
    }
    
    func isValid()->Bool{
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        print(date,self.expire_date)
            if date <= self.expire_date {
                return true
            }
        return false
    }
}
