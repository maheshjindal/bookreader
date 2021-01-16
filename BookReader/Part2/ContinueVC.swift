//
//  ContinueVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 23/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import CoreData

class ContinueVC: UIViewController {

    var lastComic:Comic!
    var delegate:TransferComicDelegate?

    var chaptersReaded:Int?{
        didSet{
            self.lastReadingTitle.text = self.lastComic.title
            self.lastReadingAuthor.text = self.lastComic.author
            self.lastReadingImage.image = fetchImageFromURL(link: self.lastComic.image)
            self.lastReadingChaptersLeft.text = String(self.lastComic.pages - self.chaptersReaded!)
            self.chaptersReadedProgressBar.progress = Float(self.chaptersReaded!)/Float(self.lastComic.pages)
            self.chaptersReadedProgressBar.progressViewStyle = .bar
            self.delegate?.setComic(comic: lastComic)
            
        }
    }
    @IBOutlet weak var lastReadingImage: UIImageView!
    
    @IBOutlet weak var chaptersReadedProgressBar: UIProgressView!
    @IBOutlet weak var lastReadingTitle: UILabel!
    @IBOutlet weak var lastReadingAuthor: UILabel!
    
    @IBOutlet weak var chaptersLeftStaticLabel: UILabel!
    @IBOutlet weak var lastReadingChaptersLeft: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLastReadDetails()
        self.lastReadingChaptersLeft.makeNonColorCircle()
        self.lastReadingTitle.makeShadow()
        self.chaptersReadedProgressBar.addRadius()
        self.lastReadingImage.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor: 6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLastReadDetails()
    }
    
    func updateLastReadDetails(){
        var detailsFound = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "LastRead")
        request.fetchLimit = 1
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
            if results.count > 0 {
                for result in results{
                    let id = result.value(forKey: "id") as! String
                    let title = result.value(forKey: "title") as! String
                    let author = result.value(forKey: "author") as! String
                    let description = result.value(forKey: "comic_description") as! String
                    let image = result.value(forKey: "image") as! String
                    let pages = result.value(forKey: "pages") as! String
                    let price = result.value(forKey: "price") as! String
                    self.lastComic = Comic(id: Int(id)!, title: title, author: author, price: price, image: image, description: description, pages: Int(pages)!)
                    break
                }
                detailsFound = true
            }
            
        } catch {
            print("Failed to fetch the data")
        }
        
        if(!detailsFound){
            updateLabels(value: true)
        }else{
            findChaptersReaded()
            updateLabels(value: false)
        }
    }
    
    func findChaptersReaded(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Chapters")
        request.predicate = NSPredicate(format: "bookid = %@", String(self.lastComic.id))
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(request)
        } catch {
            print("Failed to fetch the data")
        }
        if results.count > 0{
            self.chaptersReaded = results.count
        }else{
            self.chaptersReaded = 0
        }
        
    }
    
    func updateLabels(value:Bool){
        self.lastReadingImage.isHidden = value
        self.lastReadingTitle.isHidden = value
        self.lastReadingAuthor.isHidden = value
        self.chaptersLeftStaticLabel.isHidden = value
        self.lastReadingChaptersLeft.isHidden = value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
