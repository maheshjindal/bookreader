//
//  ReadBook.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 23/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation

class ReadBook{
    var bookId:Int!
    var chaptersReaded:Int!
    
    init(bookId:Int) {
        self.bookId = bookId
        self.chaptersReaded = 1
    }
    
    func chapterIncrement(){
        self.chaptersReaded += 1
    }
    
}
class BookWithChapters{
    var readbook:ReadBook!
    var comic:Comic!
    init(readBook:ReadBook, comic:Comic) {
        self.readbook = readBook
        self.comic = comic
    }
}

func findBookInBooks(bookWithChapters:[BookWithChapters],bookId:Int)->Int{
        var currIndex = 0;
        var found = false
        for book in bookWithChapters{
            if book.readbook.bookId == bookId {
                found = true
                break
            }
            currIndex += 1
        }
    if found{
        return currIndex
    }
        return -1
    }


