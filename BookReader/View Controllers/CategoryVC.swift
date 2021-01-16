//
//  CategoryVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 04/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//
import UIKit

private let reuseIdentifier = "categoryCell"

class CategoryVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    fileprivate let itemsPerRow:CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var categoryItems:[Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryItems = []
        updateCategoryItems()
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
    
    func startLoader() {
        activityInd.isHidden = false
        activityInd.startAnimating()
        activityInd.hidesWhenStopped = true
    }
    func stopLoader() {
        activityInd.stopAnimating()
        activityInd.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func updateCategoryItems() {
        
        DispatchQueue.main.async {
            self.startLoader()
        }
        
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
                        data, options:[]) as? [AnyObject]
                    
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
                    self.categoryItems.append(newCategory)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.stopLoader()
                }
            }
        }
        task.resume()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        if (categoryItems.count > 0) {
            cell.category = self.categoryItems[indexPath.row]
            
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCategory = self.categoryItems[indexPath.row]
        var controller:CategoryDetailVC
        controller = storyboard?.instantiateViewController(withIdentifier: "categoryDetailVC") as! CategoryDetailVC
        controller.currentCategory = currentCategory
        if let title = currentCategory.title{
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
        return CGSize(width: widthPerItem, height: 1.6*widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}
