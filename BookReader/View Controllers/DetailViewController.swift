//
//  DetailViewController.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 14/01/19.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import CoreData



class DetailViewController: UITableViewController {
    var activityIndicator: UIActivityIndicatorView!
    private var contentIssue = false
    var currentStoryItem:Comic!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var readNowBtn: UIButton!
    @IBOutlet weak var storyImage: customImageView!
    @IBOutlet weak var numberOfChapters: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var storyDetails: UITextView!
    var favouriteBtnLabel: UIButton!
    @IBOutlet weak var authorName: UILabel!
    var isFavourite = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        print("from view did load")
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.tableView.backgroundView = self.activityIndicator
        self.activityIndicator.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.readNowBtn.setGradient(color1: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),color2: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))
        self.updateContent()
        self.tabBarController?.tabBar.isHidden = true
        
//        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        
        self.favouriteBtnLabel = addFavouriteButton(navigationItem: self.navigationItem, target:self, action:#selector(favouriteBtnPressed(_:)))
        
    }
    
    func updateContent(){
        DispatchQueue.main.async {
            if let title = self.currentStoryItem?.title{
                self.bookTitle.text = title
                print(title)
            }
            
            if let author = self.currentStoryItem?.author{
                self.authorName.text = author
            }
            if let pages = self.currentStoryItem?.pages{
                self.numberOfChapters.text = String(pages)
                
            }
            if let description = self.currentStoryItem?.description{
                self.storyDetails.text = description
            }
            if let image = self.currentStoryItem?.image{
                self.storyImage.setupThumbnailImageFromURL(imageURL: image)
//                self.storyImage.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor:6)
                
//                self.storyImage.addShadowAndRadius(shadow_color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),curveFactor: 12)
                self.imageOuterView.addShadowToView(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            }
            self.numberOfChapters.makeNonColorCircle()
            self.updateIsFavourite()
            self.checkContentIssue()
            self.tableView.reloadData()
            self.stopanimate()
        }

    }
    
    func checkContentIssue(){
        if (self.currentStoryItem.title.contentIssue() || self.currentStoryItem.description.contentIssue()){
            self.contentIssue = true
        }
    }
    func updateFavouriteColor(backgroundColor: UIColor, tintColor:UIColor,shadowColor:UIColor){
        self.favouriteBtnLabel.setImage(#imageLiteral(resourceName: "star-20").withRenderingMode(.alwaysTemplate), for: .normal)
        self.favouriteBtnLabel.backgroundColor = backgroundColor
        self.favouriteBtnLabel.tintColor = tintColor
        self.favouriteBtnLabel.layer.cornerRadius = self.favouriteBtnLabel.frame.width*0.5
        self.favouriteBtnLabel.layer.shadowColor = shadowColor.cgColor
        self.favouriteBtnLabel.layer.shadowOpacity = 0.8
//        self.favouriteBtnLabel.layer.shadowRadius = self.favouriteBtnLabel.frame.width*0.5
        self.favouriteBtnLabel.layer.shadowOffset = CGSize(width: 0.3, height: 0.2)
        self.favouriteBtnLabel.layer.borderColor = tintColor.cgColor
//        self.favouriteBtnLabel.layer.borderWidth = 1.0
        
        
    }
    
    @objc func favouriteBtnPressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Comics", in: context)
       
        if(!isFavourite) {
            let newFavouriteComic = NSManagedObject(entity: entity!, insertInto: context)
            newFavouriteComic.setValue(currentStoryItem?.author,forKey:"author")
            newFavouriteComic.setValue(String(currentStoryItem!.id),forKey:"id")
            newFavouriteComic.setValue(currentStoryItem?.image,forKey:"image")
            newFavouriteComic.setValue(String(currentStoryItem!.pages),forKey:"pages")
            newFavouriteComic.setValue(currentStoryItem?.price,forKey:"price")
            newFavouriteComic.setValue(currentStoryItem?.title,forKey:"title")
            newFavouriteComic.setValue(currentStoryItem?.description,forKey:"comic_description")
            do{
                try context.save()
                print("Data Saved")
                updateFavouriteColor(backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), tintColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1),shadowColor:#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1))
                self.isFavourite = true
            } catch {
                print("Couldn't save data")
            }
        } else {
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "Comics")
            request.predicate = NSPredicate(format: "id = %@", String(self.currentStoryItem!.id))
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
                self.isFavourite = false
                updateFavouriteColor(backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), tintColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,shadowColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                
            } catch {
                print("Couldn't update deleted data")
            }
        }
        
    }
    
    func updateIsFavourite() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Comics")
        request.predicate = NSPredicate(format: "id = %@", String(self.currentStoryItem!.id))
        request.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            
        } catch {
            
            print("Failed to fetch the data")
        }
        if(results.count > 0){
            self.isFavourite = true
            updateFavouriteColor(backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), tintColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1),shadowColor:#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1))
        }else{
            updateFavouriteColor(backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),shadowColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            
        }
        
    }
    
    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    @IBAction func readNowBtn(_ sender: Any) {
        if !contentIssue{
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
                    result.setValue(currentStoryItem.author,forKey:"author")
                    result.setValue(String(currentStoryItem.id),forKey:"id")
                    result.setValue(currentStoryItem.image,forKey:"image")
                    result.setValue(String(currentStoryItem.pages),forKey:"pages")
                    result.setValue(currentStoryItem.price,forKey:"price")
                    result.setValue(currentStoryItem.title,forKey:"title")
                    result.setValue(currentStoryItem.description,forKey:"comic_description")
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
            newLastReadItem.setValue(currentStoryItem.author,forKey:"author")
            newLastReadItem.setValue(String(currentStoryItem.id),forKey:"id")
            newLastReadItem.setValue(currentStoryItem.image,forKey:"image")
            newLastReadItem.setValue(String(currentStoryItem.pages),forKey:"pages")
            newLastReadItem.setValue(currentStoryItem.price,forKey:"price")
            newLastReadItem.setValue(currentStoryItem.title,forKey:"title")
            newLastReadItem.setValue(currentStoryItem.description,forKey:"comic_description")
            do{
                try context.save()
                print("new item added")
            } catch {
                print("Couldn't save data")
            }
            
            
        }
        performSegue(withIdentifier: "chapterSegue", sender: nil)
            
        }else{
            //content Problem
            
            let message = "We  respect user preferences and comply with legal regulations, so we don’t allow certain kinds of adult content in comics and manga. Some kinds of adult-oriented manga and destinations are allowed if they comply with the policies below and don’t target minors, but they will only show in limited scenarios based on user search queries, user age, and local laws where the manga is being served.\nHowever if you find any objectionable content of this app, please report it to dblockapp@gmail.com"
            let alert = UIAlertController(title: "Content Issue", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    func stopanimate(){
        self.activityIndicator.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chapterSegue" {
            if let destinationVC = segue.destination as? ChaptersVC {
                destinationVC.currentComic = currentStoryItem
                if let comicId = currentStoryItem.id{
                    destinationVC.bookId = comicId
                }
            }
        }

    }
    

    
}

extension String{
    func contentIssue()->Bool{
        if(self.lowercased().range(of: "sex") != nil || self.lowercased().range(of: "adult") != nil || self.lowercased().range(of: "erotic") != nil || self.lowercased().range(of: "virgin") != nil || self.lowercased().range(of: "nude") != nil || self.lowercased().range(of: "porn") != nil || self.lowercased().range(of: "fuck") != nil || self.lowercased().range(of: "kijima") != nil ){
            return true
        }
        return false
    }
}
