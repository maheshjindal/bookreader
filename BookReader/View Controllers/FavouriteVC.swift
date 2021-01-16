//
//  FavouriteVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import CoreData


private let reuseIdentifier = "favouriteComicCell"

class FavouriteVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    fileprivate let itemsPerRow:CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var favouriteComicsList:[Comic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favouriteComicsList = []
        updateFavouriteComicsList()
         self.collectionView.reloadData()
        self.navigationItem.addLogo()
        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        updateShadow(navigationController: self.navigationController!)
    }
    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.favouriteComicsList = []
        updateFavouriteComicsList()
         self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.favouriteComicsList = []
        updateFavouriteComicsList()
         self.collectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.favouriteComicsList = []
        updateFavouriteComicsList()
        self.collectionView.reloadData()
    }
  
//    func handleSwipes(sender: UISwipeGestureRecognizer) {
//        if(sender.direction == .left){
//            tabBarController?.selectedIndex = 2
//        }
//        if (sender.direction == .right) {
//            tabBarController?.selectedIndex = 0
//        }
//    }
    
    func updateFavouriteComicsList() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Comics")
        
        var results: [NSFetchRequestResult] = []
        do {
            results = try context.fetch(fetchRequest)
            
        } catch {
            print("Failed to fetch the results")
        }
        
        if(results.count > 0) {
            for result in results as! [NSManagedObject] {
               let id = result.value(forKey: "id") as! String
               let title = result.value(forKey: "title") as! String
               let author = result.value(forKey: "author") as! String
               let description = result.value(forKey: "comic_description") as! String
               let image = result.value(forKey: "image") as! String
               let pages = result.value(forKey: "pages") as! String
               let price = result.value(forKey: "price") as! String
               let newComic = Comic(id: Int(id)!, title: title, author: author, price: price, image: image, description: description, pages: Int(pages)!)
               self.favouriteComicsList.append(newComic)
            }
            self.collectionView.reloadData()
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favouriteComicsList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        if (favouriteComicsList.count > 0) {
            cell.comic = self.favouriteComicsList[indexPath.row]
    
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentComic = self.favouriteComicsList[indexPath.row]
        var controller:DetailViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.currentStoryItem = currentComic
        if let title = currentComic.title{
            controller.title = title
        }else{
            controller.title = ""
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 1.5*widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }


}
