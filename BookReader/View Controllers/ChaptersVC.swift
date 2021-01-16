//
//  PagesVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import CoreData

class ChaptersVC: UITableViewController {
    var bookId:Int!
    var currentComic:Comic!
    var chaptersList:[Chapter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(bookId)
        UpdateStories(bookId: self.bookId)
        addShadowToBar(navigationController: self.navigationController!)
        self.tabBarController?.tabBar.isHidden = true
   
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("didappear")
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
    func UpdateStories(bookId:Int) {
    
        
        let requestURL = URL(string: "http://api.acgmonster.com/comics/\(String(bookId))?package_name=com.acg.manga&version_code=169&version_name=1.1.6.9&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        print(requestURL)
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if(error != nil){
                print(error ?? "problem in fetching data")
            }else{
                guard let data = data else{
                    print("data not found")
                    return
                }
                var jsonResponse:[String:AnyObject]!
                do{
                    jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options:[]) as? [String:AnyObject]
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                guard let response = jsonResponse else{
                    print("problem in getting data")
                    return
                }
                guard let all_chapters = response["chapters"] as? NSArray else{
                    print("Problem in getting chapters")
                    return
                }
                for chapter in all_chapters{
                    guard let chapter = chapter as? [String:AnyObject] else {
                        print("Chapter not found")
                        return
                    }
                    guard let book_title = chapter["name"] as? String,let book_index = chapter["index"] as? Int else{
                        return
                    }
                    let newChapter = Chapter(title: book_title, index: book_index)
                    self.chaptersList.append(newChapter)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chaptersList.count
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! TopTableViewCell
        if(self.chaptersList.count > 0){
            if let currentChapterTitle = self.chaptersList[indexPath.row].title{
            cell.heading.text = "\(indexPath.row + 1). \(currentChapterTitle)"
            }
            if(updateCheckMarkForIndex(chapter:self.chaptersList[indexPath.row],bookId: self.bookId)){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }

        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller:BookVC
        controller = storyboard?.instantiateViewController(withIdentifier: "BookVC") as! BookVC
        controller.bookId = self.bookId
        controller.chapterIndex = self.chaptersList[indexPath.row].index
        updateContinueReading()
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                removePageFromDatabase(chapter: self.chaptersList[indexPath.row],bookId: self.bookId)
            }else{
                addPageToDatabase(chapter: self.chaptersList[indexPath.row], bookId:self.bookId)
                cell.accessoryType = .checkmark
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func updateContinueReading(){
        var isUpdated = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "LastRead")
        request.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    result.setValue(currentComic.author,forKey:"author")
                    result.setValue(String(currentComic.id),forKey:"id")
                    result.setValue(currentComic.image,forKey:"image")
                    result.setValue(String(currentComic.pages),forKey:"pages")
                    result.setValue(currentComic.price,forKey:"price")
                    result.setValue(currentComic.title,forKey:"title")
                    result.setValue(currentComic.description,forKey:"comic_description")
                }
                do{
                    try context.save()
                    isUpdated = true
                    print("item is updated")
                }catch{
                    print("Couldnot update value")
                }
            }
            
            
        } catch {
            print("Failed to fetch the data")
        }
        if(!isUpdated){
            let entity = NSEntityDescription.entity(forEntityName: "LastRead", in: context)
            let newLastReadItem = NSManagedObject(entity: entity!, insertInto: context)
            newLastReadItem.setValue(currentComic.author,forKey:"author")
            newLastReadItem.setValue(String(currentComic.id),forKey:"id")
            newLastReadItem.setValue( currentComic.image,forKey:"image")
            newLastReadItem.setValue(String(currentComic.pages),forKey:"pages")
            newLastReadItem.setValue(currentComic.price,forKey:"price")
            newLastReadItem.setValue(currentComic.title,forKey:"title")
            newLastReadItem.setValue(currentComic.description,forKey:"comic_description")
            do{
                try context.save()
                print("new item added")
            } catch {
                print("Couldn't save data")
            }
            
        }
    }
    func addPageToDatabase(chapter:Chapter, bookId: Int){
        let index = String(chapter.index)
        let chapterTitle = chapter.title
        let currentBookId = String(bookId)
        let currentDate = Date()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Chapters", in: context)
       
            let newBookChapters = NSManagedObject(entity: entity!, insertInto: context)
            newBookChapters.setValue(index,forKey:"index")
            newBookChapters.setValue(chapterTitle,forKey:"title")
            newBookChapters.setValue(currentBookId,forKey:"bookid")
            newBookChapters.setValue(currentDate,forKey:"date")
            newBookChapters.setValue(currentComic.author,forKey:"comic_author")
            newBookChapters.setValue(currentComic.image,forKey:"comic_image")
            newBookChapters.setValue(String(currentComic.pages),forKey:"comic_pages")
            newBookChapters.setValue(currentComic.price,forKey:"comic_price")
            newBookChapters.setValue(currentComic.title,forKey:"comic_title")
            newBookChapters.setValue(currentComic.description,forKey:"comic_description")
            do{
                try context.save()
                print("Data Saved")
            } catch {
                print("Couldn't save data")
            }
    }
    
    func removePageFromDatabase(chapter:Chapter, bookId:Int){
        let chapterIndex = String(chapter.index)
        let bookId = String(bookId)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Chapters")
        request.predicate = NSPredicate(format: "index = %@ AND bookid = %@", chapterIndex,bookId)
        request.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            if(results.count > 0 ){
                context.delete(results[0])
            }
            
        } catch {
            
            print("Failed to delete the data")
        }
        do{
            try context.save()
            print("Data deleted")
            
        } catch {
            print("Couldn't update deleted data")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func updateCheckMarkForIndex(chapter:Chapter,bookId:Int)->Bool{
        let chapterIndex = String(chapter.index)
        let bookId = String(bookId)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Chapters")
        request.predicate = NSPredicate(format: "index = %@ AND bookid = %@", chapterIndex,bookId)
        request.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            
            
        } catch {
            
            print("Failed to fetch the data")
        }
        if(results.count > 0){
          return true
        }
         return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }

   

}
