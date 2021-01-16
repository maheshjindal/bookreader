//
//  CategoryDetailVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 04/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "categoryDetailCell"

class CategoryDetailVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var activityInd: UIActivityIndicatorView!

    fileprivate let itemsPerRow:CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var currentCategory:Category!
    var categoryItemDetails:[Comic] = []
    
    var isFetchingMore = false
    var page = 1
    var total_pages = 0
    var task:URLSessionDataTask!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryItemDetails = []
        updateCategoryItemDetails(category: self.currentCategory, page: self.page)
        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }

    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func startLoader() {
        activityInd.isHidden = false
        activityInd.startAnimating()
        activityInd.hidesWhenStopped = true
    }
    func stopLoader() {
        activityInd.stopAnimating()
        activityInd.isHidden = true
    }
    
    
    
    func updateCategoryItemDetails(category: Category, page: Int) {
        
        self.isFetchingMore = true
        DispatchQueue.main.async {
            self.startLoader()
        }
        let requestURL = URL(string: "http://api.acgmonster.com\(category.query_url ?? "")&page=\(String(page))&package_name=com.acg.manga&version_code=170&version_name=1.1.7.0&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        self.task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if(error != nil){
                print(error ?? "problem in fetching data")
            }else{
                guard let data = data else{
                    print("data not found")
                    return
                }
                
                var jsonResponse:[String:Any]!
                do{
                    jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options:[]) as? [String:AnyObject]
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                guard let total_pages = jsonResponse["total_pages"] as? Int else{
                    print("problem in getting data")
                    return
                }
                self.total_pages = total_pages
                print(self.total_pages)
                guard let entries = jsonResponse["entries"] as? NSArray else{
                    print("problem in getting entries")
                    return
                }
                for comic in entries{
                    
                    var sex = false
                    guard let comic = comic as? [String:AnyObject] else{
                        continue
                    }
                    guard let comic_id = comic["id"] as? Int ,let comic_pages = comic["chapters_count"] as? Int else{
                        print("Id,pages not found")
                        continue
                    }
                    guard let comic_title = comic["name"] as? String,let comic_author = comic["author"] as? String ,let comic_desc = comic["description"] as? String, let comic_cover = comic["cover"]  as? String else{
                        continue
                    }
                    let book = Comic(id: comic_id , title: comic_title ,author:comic_author,image: comic_cover, description: comic_desc, pages: comic_pages)
                    
                    guard let taglist = comic["tag_list"] as? NSArray else{
                        continue
                    }
                    
                    for tag in taglist{
                        guard let tag = tag as? String else{
                            continue
                        }
                        if(tag.lowercased().range(of: "mature") != nil || tag.lowercased().range(of: "adult") != nil){
                            sex = true
                        }
                    }
                    if(!sex){
                        self.categoryItemDetails.append(book)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.page += 1
                
            }
             self.isFetchingMore = false
        }
        self.task.resume()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryItemDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        if (categoryItemDetails.count > 0) {
            cell.comic = self.categoryItemDetails[indexPath.row]
            
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentComic = self.categoryItemDetails[indexPath.row]
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(offsetY > contentHeight - scrollView.frame.height && self.page<=self.total_pages) {
            print(isFetchingMore)
            if !self.isFetchingMore{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                    self.updateCategoryItemDetails(category: self.currentCategory, page: self.page)
                    self.stopLoader()
                    self.isFetchingMore = true
                    
                }
                
            }
            
        }
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
