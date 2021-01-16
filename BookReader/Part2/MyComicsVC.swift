//
//  MyComicsVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 23/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import CoreData

class MyComicsVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var delegate:CheckItemsDelegate?
    var myMangasList:[BookWithChapters] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        fetchMyMangas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyMangas()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myMangasList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myMangaCollectionViewCell", for: indexPath) as! MyMangaCollectionViewCell
        if self.myMangasList.count > 0{
            print("reached here")
           cell.currentComic = self.myMangasList[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var controller:ChaptersVC
        controller = storyboard?.instantiateViewController(withIdentifier: "ChaptersVC") as! ChaptersVC
        let currentComic = self.myMangasList[indexPath.row]
        controller.currentComic = currentComic.comic
        controller.bookId = currentComic.comic.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func fetchMyMangas(){
        self.myMangasList = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Chapters")
         let sort = NSSortDescriptor(key: #keyPath(Chapters.date), ascending: false)
        request.sortDescriptors = [sort]
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            if(results.count > 0 ){
                for result in results{
                    let foundbookId = result.value(forKey: "bookid") as! String
                    let bookId = Int(foundbookId)!
                    let title = result.value(forKey: "comic_title") as! String
                    let author = result.value(forKey: "comic_author") as! String
                    let description = result.value(forKey: "comic_description") as! String
                    let image = result.value(forKey: "comic_image") as! String
                    let pages = result.value(forKey: "comic_pages") as! String
                    let price = result.value(forKey: "comic_price") as! String
                    let foundIndex = findBookInBooks(bookWithChapters:self.myMangasList,bookId:bookId)
                    if foundIndex == -1 {
                        let readBook = ReadBook(bookId: bookId)
                        let comic = Comic(id: bookId, title: title, author: author, price:price, image: image, description: description, pages: Int(pages)!)
                        let bookWithChapters = BookWithChapters(readBook: readBook,comic: comic)
                        self.myMangasList.append(bookWithChapters)
                    }else{
                        self.myMangasList[foundIndex].readbook.chapterIncrement()
                    }
                    
                }
               
            }
            
        } catch {
            self.delegate!.isItemAvailable(item:true)
            print("Failed to delete the data")
        }
        
        if(results.count > 0){
            self.collectionView.reloadData()
            self.delegate!.isItemAvailable(item:true)
        }else{
           self.delegate!.isItemAvailable(item:false)
        }
    }
    
    fileprivate let itemsPerRow:CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10.0, bottom: 5, right: 10.0)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
   
    


}
