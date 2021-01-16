//
//  TableViewController.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 21/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class TableDetailVC: UITableViewController {
    var delegate:SwipeDelegate?
    private var isFetchingMore = false
    private var anotherSectionNeeded = false
    private var page = 1
    private var total_pages = 0
    private var mainItemsCount = 6
    private var mainTtems:[Comic] = []
    private var categoryHeaders = ["Trending", "List"]
    private var homeSectionItems:[HomeSection] = []
    var currentCategory:String = "home"
    var comicsList:[Comic] = []
    var loadedImages:[UIImage] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        self.comicsList = []
        self.tableView.sectionHeaderHeight = 50
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        

        self.mainItemsCount = 6
        self.homeSectionItems = []
        self.mainTtems = []
        anotherSectionNeeded = false
        if currentCategory == "home" {
            setupHomeList()
        }else{
            getComicsList(currentCategory: self.currentCategory, page: 1)
        }
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        stopAnimation()

    }
    
  
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .left {
            delegate!.setSwipe(direction: .right)
        }
        if sender.direction == .right {
            delegate!.setSwipe(direction: .left)
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryHeaders[section]
    }
    
     func updateContent(){
        self.comicsList = []
        self.mainItemsCount = 6
        self.homeSectionItems = []
        anotherSectionNeeded = false

        self.mainTtems = []
        if currentCategory == "home" {
            setupHomeList()
        }else{
            getComicsList(currentCategory: self.currentCategory, page: 1)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }
        return 150
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if currentCategory == "home"{
            return self.homeSectionItems.count
        }
        if anotherSectionNeeded{
            return categoryHeaders.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCategory == "home"{
            if section == 0 {
                return 1
            }else{
                 return self.homeSectionItems[section].getComicsCount()
            }
        }else{
            if section == 0 {
                return 1
            }else{
                return comicsList.count
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.size.width, height: 40))
        if currentCategory == "home"{
            label.text = self.homeSectionItems[section].name
        }else{
            label.text = self.categoryHeaders[section]
        }
        label.setupDetails()
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-20).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.currentCategory == "home"{
            let currentSection = self.homeSectionItems[indexPath.section]
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "topContent", for: indexPath) as! MainCategoryVC
                cell.mainComicsList = currentSection.comicsList
                cell.tableDetailViewController = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "listDetails", for: indexPath) as! CategoryListCell
                if(currentSection.getComicsCount() > 0){
                    cell.comic = currentSection.comicsList[indexPath.row]
                }
                return cell
            }
        }else{
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "topContent", for: indexPath) as! MainCategoryVC
                if self.mainTtems.count > 0{
                    cell.mainComicsList = self.mainTtems
                }
                cell.tableDetailViewController = self
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "listDetails", for: indexPath) as! CategoryListCell
                if(self.comicsList.count > 0){
                    cell.comic = self.comicsList[indexPath.row]
                }
                return cell
            }
        }
    }
    
    func showCategoryDetails(item: Comic){
        var controller:DetailViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.currentStoryItem = item
        if item.title != nil{
            controller.title = "Book Description"
        }else{
            controller.title = ""
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func setupHomeList(){
        self.isFetchingMore = true
        
        let requestURL = URL(string: "http://api.acgmonster.com/comics/features?package_name=com.acg.manga&version_code=169&version_name=1.1.6.9&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
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
                        data, options:[.mutableContainers]) as? [String:AnyObject]
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                guard let slideshows = jsonResponse["slideshows"] as? NSArray else{
                    print("problem in slideshow data")
                    return
                }
                let trendingSection = HomeSection(name: "Trending")
                
                for slide in slideshows{
                    guard let slide = slide as? [String:AnyObject] else{
                        continue
                    }
                    guard let comics = slide["comics"] as? NSArray else{
                        continue
                    }
                    for comic in comics{
                        
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
                        trendingSection.addElement(comic: book)
                    }
                }
                self.homeSectionItems.append(trendingSection)
                
                guard let subjects = jsonResponse["subjects"] as? NSArray else{
                    print("problem in getting entries")
                    return
                }
                for subject in subjects{
                    guard let subject = subject as? [String:AnyObject] else{
                        continue
                    }
                    guard let cat_header = subject["name"] as? String else{
                        continue
                    }
                    
                    let category_section = HomeSection(name: cat_header)
                    guard let comics = subject["comics"] as? NSArray else{
                        continue
                    }
                    
                    for comic in comics{
                        
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
                            category_section.addElement(comic: book)
                    }
                    self.homeSectionItems.append(category_section)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            print("Home section items length")
            print(self.homeSectionItems.count)
            
            self.isFetchingMore = false
        }
       
        task.resume()
    }
    
    
    private func getComicsList(currentCategory:String, page:Int) {
        self.isFetchingMore = true
        
        let requestURL = URL(string: "http://api.acgmonster.com/comics?q[tags_name_eq]=\(currentCategory)&page=\(String(page))&package_name=com.acg.manga&version_code=170&version_name=1.1.7.0&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
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
                        if(self.mainItemsCount > 0){
                            self.mainTtems.append(book)
                            self.mainItemsCount -= 1
                            print("Main items count is \(self.mainItemsCount)")
                        }else{
                            self.anotherSectionNeeded = true
                            self.comicsList.append(book)
                        }
                        DispatchQueue.main.async {
                             self.tableView.reloadData()
                        }
                        
                    }
                }
               
                self.page += 1
                
            }
               self.isFetchingMore = false
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller:DetailViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if currentCategory == "home"{
            let currentSection = homeSectionItems[indexPath.section]
            let item = currentSection.comicsList[indexPath.row]
            controller.currentStoryItem = item
            if item.title != nil{
                controller.title = "Book Description"
            }else{
                controller.title = ""
            }
        }else{
            let item = self.comicsList[indexPath.row]
            controller.currentStoryItem = item
            if item.title != nil{
                controller.title = "Book Description"
            }else{
                controller.title = ""
            }
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
                    self.getComicsList(currentCategory: self.currentCategory, page: self.page)
                    self.isFetchingMore = true
                    
                }
                
            }
            
        }
    }

}


