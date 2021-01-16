//
//  SearchVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class SearchVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIScrollViewDelegate {
    fileprivate let itemsPerRow:CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let delegate = UIApplication.shared.delegate as! AppDelegate

    var searchItemsList:[Comic] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activitvityInd: UIActivityIndicatorView!
    var searchingText:String!
    var isFetchingMore = false
    var page = 1
    var total_pages = 0
    var task:URLSessionDataTask!
        
    func startLoader() {
        activitvityInd.isHidden = false
        activitvityInd.startAnimating()
        activitvityInd.hidesWhenStopped = true
    }
    func stopLoader() {
        activitvityInd.stopAnimating()
        activitvityInd.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchItem", for: indexPath) as! HomeCollectionViewCell
        if(self.searchItemsList.count > 0){
            cell.comic = self.searchItemsList[indexPath.row]
        }
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
//        self.searchItemsList = []
//        self.collectionView.reloadData()
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.task != nil{
            self.task.cancel()
        }
        self.page = 1
        self.searchItemsList = []
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.searchingText = searchBar.text
        print(searchingText)
        UpdateStories(search: self.searchingText, page: self.page)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
//        self.searchItemsList = []
//        self.collectionView.reloadData()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.continueViewClicked))
        self.view.addGestureRecognizer(gesture)
        gesture.cancelsTouchesInView = false
        activitvityInd.isHidden = true
    }
    
    @objc func continueViewClicked(){
       searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentComic = self.searchItemsList[indexPath.row]
        var controller:DetailViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.currentStoryItem = currentComic
        controller.title = "Book Description"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func UpdateStories(search:String, page:Int) {
        isFetchingMore = true
        DispatchQueue.main.async {
              self.startLoader()
        }
        let newSearch = search.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let requestURL = URL(string: "http://api.acgmonster.com/comics?q[name_cont]=\(newSearch)&page=\(String(page))&package_name=com.acg.manga&version_code=170&version_name=1.1.7.0&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        
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
                            return
                        }
                        if(tag.lowercased().range(of: "mature") != nil || tag.lowercased().range(of: "adult") != nil){
                            sex = true
                        }
                    }
                    if(!sex){
                        self.searchItemsList.append(book)
                    }
                }
                print(requestURL)
                
                
                DispatchQueue.main.async {
                    print("reached here")
                    self.collectionView.reloadData()
                    self.stopLoader()
                }
                self.page += 1
            }
           self.isFetchingMore = false
        }
        self.task.resume()
        
    }
    
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if(offsetY > contentHeight - scrollView.frame.height && self.page<=self.total_pages) {
//            if !isFetchingMore{
//                    self.UpdateStories(search: self.searchingText, page: self.page)
//            }
//
//        }
//    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(offsetY > contentHeight - scrollView.frame.height && self.page<=self.total_pages) {
            print(isFetchingMore)
            if !self.isFetchingMore{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                    self.UpdateStories(search: self.searchingText, page: self.page)
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
