//
//  SubscriptionVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 12/01/19.
//  Copyright © 2019 MaheshJindal. All rights reserved.
//

import UIKit
import StoreKit


class SubscriptionVC: UITableViewController {
    var activityIndicator: UIActivityIndicatorView!
    var products:[SKProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.view.frame.width/2)-10, y: (self.view.frame.height/2)-10, width: 20, height: 20))
        self.tableView.backgroundView = self.activityIndicator
        self.activityIndicator.style = .whiteLarge
        self.activityIndicator.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.activityIndicator.hidesWhenStopped = true
        self.products = []
        AppPurchaseService.shared.getProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(handleOptionsLoaded(notification:)), name: AppPurchaseService.productsLoadedNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(handleReach(notification:)), name: AppPurchaseService.goToHomePage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startLoader(notification:)), name: AppPurchaseService.startLoaderNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoader(notification:)), name: AppPurchaseService.stopLoaderNotification, object: nil)
        
        self.tableView.reloadData()
    }
    
    @objc func handleReach(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            let controller:UITabBarController
            controller = (self!.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController)!
            self!.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func startLoader(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    @objc func stopLoader(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc func handleOptionsLoaded(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.products = AppPurchaseService.shared.products!
            self?.products.sort(by: { (p0, p1) -> Bool in
                return p0.price.floatValue < p1.price.floatValue
            })
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.products.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionTableViewCell
        if(self.products.count > 0){
            let currProduct = self.products[indexPath.row]
            cell.subscriptionTitle.text = currProduct.localizedTitle
            cell.subscriptionDescription.text = currProduct.localizedDescription
            cell.subscriptionAmount.text = formatter.string(from: currProduct.price) ?? "\(currProduct.price)"
            
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppPurchaseService.shared.purchase(product:self.products[indexPath.row])
    }
 


}
