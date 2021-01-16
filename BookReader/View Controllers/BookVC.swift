//
//  BookVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class BookVC: UITableViewController {
    var bookId:Int!
     var activityInd: UIActivityIndicatorView!
    
    var chapterIndex:Int!
    var pagesList:[Page] = []
    var isFetchingMore = false
    var task:URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bookId)
        print(chapterIndex)
        addShadowToBar(navigationController: self.navigationController!)
        self.tabBarController?.tabBar.isHidden = true
        self.activityInd = UIActivityIndicatorView(style: .whiteLarge)
        self.tableView.backgroundView = self.activityInd
        self.activityInd.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.activityInd.isHidden = false
        self.activityInd.startAnimating()
        self.activityInd.hidesWhenStopped = true
        self.tableView.estimatedRowHeight = self.tableView.frame.height - self.tableView.frame.height/2


        UpdateStories(bookId: self.bookId, chapterIndex: self.chapterIndex)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height/1.2
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
    }
        override func viewWillAppear(_ animated: Bool) {
        }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
        
    func UpdateStories(bookId:Int, chapterIndex:Int) {
        self.pagesList = []
            isFetchingMore = true
        
        let requestURL = URL(string: "http://api.acgmonster.com/comics/\(String(bookId))/\(String(chapterIndex))?package_name=com.acg.manga&version_code=170&version_name=1.1.7.0&channel=google&sign=abf5f3c86df625ef6e43f1ad8a82066d&platform=android&lang=en&country=IN&sim=in")!
            print("Requesting")
            print(requestURL)
            let request = URLRequest(url: requestURL)
        
            self.task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
                guard let all_pages = response["pages"] as? NSArray else{
                    print("Problem in getting chapters")
                    return
                }
                for page in all_pages{
                    guard let page = page as? [String:AnyObject] else {
                        print("Page not found")
                        return
                    }
                    guard let chapter_image = page["track_url"] as? String else{
                        return
                    }
                    let newPage = Page(image: chapter_image)
                    self.pagesList.append(newPage)
                   
                }
                DispatchQueue.main.async {
                    self.activityInd.stopAnimating()
                    self.activityInd.isHidden = true
                    self.tableView.reloadData()
                    
                }
            }
            
            
            self.isFetchingMore = false
        })
        
            self.task.resume()
        
        }
   
    func reloadBookView(){
        DispatchQueue.main.async{
              self.tableView.reloadData()
        }
      
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pagesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        cell.tableView = self
        if(self.pagesList.count > 0){
            cell.activityIndicator.isHidden = true
            
            cell.page = self.pagesList[indexPath.row]
        }
        return cell
    }


}
