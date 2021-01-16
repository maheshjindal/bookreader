//
//  NavigationVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 21/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit


class NavigationVC: UICollectionViewController {
   
    var swipedir:direction?{
        didSet{
            updateNavFromDir(direction: swipedir!)
        }
    }
    private var isFetchingMore = false
    private var currentSelectedIndex = 0
    private var categories = ["Home"]
    private var categoryCount = 1
    private var maxCategories = 10
    private var categoriesList:[Category] = []
    var delegate:ModifyCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryCount = 1
        UpdateCategories()
    }
  

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath.row
        let cat_name = findNameFromCategory(categoryName: self.categories[indexPath.row])
        delegate?.setCategory(categoryName: cat_name)
        self.collectionView.reloadData()
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "navheader", for: indexPath) as! ButtonVC
        
        if categoriesList.count > 0{
            cell.btnLabel.text = self.categories[indexPath.row]
        }
        cell.btnLabel.removeBottomBorder()
        if(indexPath.row == currentSelectedIndex){
            cell.btnLabel.addBottomBorder()
        }
        return cell
    }
    
    
    
    func UpdateCategories() {
        self.isFetchingMore = true
        let requestURL = URL(string: "http://api.acgmonster.com/comics/categories?package_name=com.acg.manga&version_code=170&version_name=1.1.7.0&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if(error != nil){
                print(error ?? "problem in fetching data")
            }else{
                guard let data = data else{
                    print("data not found")
                    return
                }
                var jsonResponse:[AnyObject]!
                do{
                    jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options:[.mutableContainers]) as? [AnyObject]
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                guard let response = jsonResponse else{
                    print("problem in getting data")
                    return
                }
                for category in response{
                    
                    guard let category_title = category["name"] as? String,let query_url = category["query"] as? String ,let track_url = category["track_url"] as? String, let category_image = category["cover"]  as? String else{
                        return
                    }
                    let newCategory = Category(title: category_title, image: category_image, query_url: query_url, track_url: track_url)
                    if self.categoryCount <= self.maxCategories{
                        self.categoriesList.append(newCategory)
                        self.categories.append(newCategory.title)
                        self.categoryCount += 1
                    }else{
                        break
                    }
                   
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
        task.resume()
        self.isFetchingMore = false
    }

    func updateNavFromDir(direction: direction) {
        if direction == .left{
            if currentSelectedIndex > 0 {
                currentSelectedIndex = currentSelectedIndex-1
                let cat_name = findNameFromCategory(categoryName: self.categories[currentSelectedIndex])
                delegate?.setCategory(categoryName: cat_name)
                self.collectionView.reloadData()
            }
        }
        if direction == .right{
            if currentSelectedIndex < self.categoriesList.count {
                currentSelectedIndex = currentSelectedIndex+1
                let cat_name = findNameFromCategory(categoryName: self.categories[currentSelectedIndex])
                delegate?.setCategory(categoryName: cat_name)
                self.collectionView.reloadData()
            }
            
        }
    }
}
