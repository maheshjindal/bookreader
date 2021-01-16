//
//  Story.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 28/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation
import UIKit

class Comic {
    var id:Int!
    var title:String!
    var author:String?
    var price:String?
    var image:String!
    var description:String!
    var pages:Int!
    
    init(id:Int, title:String, author:String, price:String,image:String, description:String,pages:Int) {
        self.id = id
        self.title = title
        self.author = author
        self.price = price
        self.image = image
        self.description = description
        self.pages = pages
    }
    convenience init(id:Int, title:String,author:String,image:String,description:String,pages:Int) {
        self.init(id: id,title: title,author:author,price: "",image: image,description: description,pages: pages)
    }

}
func setupThumbnailImageToImageView(comicImageView:customImageView,comic:Comic?){
    if let imageTitle = comic?.image{
            comicImageView.setupThumbnailImageFromURL(imageURL:imageTitle)
    }else{
        comicImageView.setupThumbnailImageFromURL(imageURL: nil)
    }
}
func setupBookImage(bookImageView:customImageView, imageURL:String?,activityIndicator:UIActivityIndicatorView,tableView:BookVC?){
    if let imageTitle = imageURL{
        bookImageView.setupBookImageFromURL(imageURL: imageTitle, activityIndicator: activityIndicator,tableView: tableView)
    }else{
        bookImageView.setupBookImageFromURL(imageURL: nil, activityIndicator: activityIndicator,tableView: tableView)
    }
}

//extension UIImageView{
//
//    func setupThumbnailImageFromURL(imageURL:String?){
//        if let imageURL = imageURL{
//            image = nil
//            let url = URL(string: imageURL)
//            URLSession.shared.dataTask(with: url!) { (data, response, error) in
//                if error != nil{
//                    print(error as Any)
//                    return
//                }else{
//                    if let data = data {
//                        DispatchQueue.main.async {
//                            self.image = UIImage(data: data)
//                        }
//                    }else{
//                        self.image = #imageLiteral(resourceName: "network")
//                    }
//                }
//
//            }.resume()
//        }
//    }
//}
class customImageView:UIImageView{
    var currentImage:String?
    private let delegate = UIApplication.shared.delegate as! AppDelegate

     func setupThumbnailImageFromURL(imageURL:String?){
        currentImage = imageURL
        if let imageURL = imageURL{
            image = nil
            let url = URL(string: imageURL)
            if let cachedImage = self.delegate.cachedObject.object(forKey: imageURL as NSString){
                self.image = cachedImage
                return
            }
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil{
                    print(error as Any)
                    return
                }else{
                    if let data = data {
                        DispatchQueue.main.async {
                            let cachedImg = UIImage(data: data)
                            if cachedImg != nil {
                                if(imageURL == self.currentImage){
                                    self.image = cachedImg
                                }
                                self.delegate.cachedObject.setObject(cachedImg!, forKey: imageURL as NSString)
                            }else{
                                self.image = #imageLiteral(resourceName: "network")
                            }
                        }
                    }else{
                        self.image = #imageLiteral(resourceName: "network")
                    }
                }
                
                }.resume()
        }
    }
    
    func setupBookImageFromURL(imageURL:String?,activityIndicator:UIActivityIndicatorView,tableView:BookVC?){
        currentImage = imageURL
        if let imageURL = imageURL{
            image = nil
            let url = URL(string: imageURL)
            if let cachedImage = self.delegate.cachedObject.object(forKey: imageURL as NSString){
                self.image = cachedImage
                return
            }
            var request = URLRequest(url: url!)
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            request.allowsCellularAccess = true
            
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.isHidden = false
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil{
                    print(error as Any)
                    return
                }else{
                    if let data = data {
                        DispatchQueue.main.async {
                            let cachedImg = UIImage(data: data)
                            if(imageURL == self.currentImage){
                                self.image = cachedImg
                            }
                            self.delegate.cachedObject.setObject(cachedImg!, forKey: imageURL as NSString)
                            
                            activityIndicator.stopAnimating()
                            activityIndicator.isHidden = true
                            tableView?.reloadBookView()
                        }
                    }else{
                        self.image = #imageLiteral(resourceName: "network")
                    }
                }
                
                }.resume()
        }
    }
}
