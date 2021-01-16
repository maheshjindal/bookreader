//
//  CheckSubscriptionVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 12/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import UIKit
import StoreKit

class WorkingSubscription{
    static let workingSubscriptionAvailable = Notification.Name("WorkingSubscriptionAvailable")

    var presentSubscriptionReceipt:Receipt!{
        didSet{
            NotificationCenter.default.post(name: WorkingSubscription.workingSubscriptionAvailable, object: presentSubscriptionReceipt)
        }
    }
    static let shared = WorkingSubscription()
}

class CheckSubscriptionVC: UIViewController {
    var requestRecieved = false
    var NCLabel:UILabel!
    let reachability = Reachability()!
    var activityIndicator: UIActivityIndicatorView!

    @IBAction func subscriptionClicked(_ sender: Any) {
        performSegue(withIdentifier: "subscriptionPage", sender: nil)
    }
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var subscribeBtn:UIButton!
    
    func showContent(){
        DispatchQueue.main.async {
             self.stopanimate()
            self.subscribeBtn.isHidden = false
            self.navigationController?.isNavigationBarHidden = false
            self.headingLabel.isHidden = false
            self.subHeadingLabel.isHidden = false
            self.detailLabel.isHidden = false
            self.noteLabel.isHidden = false
        }
    }
    
    func hideContent(){
        DispatchQueue.main.async {
            self.subscribeBtn.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
            self.headingLabel.isHidden = true
            self.subHeadingLabel.isHidden = true
            self.detailLabel.isHidden = true
            self.noteLabel.isHidden = true
        }
    }

    func stopanimate(){
        if self.activityIndicator != nil {
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()

            }
        }
        
     
    }
    func createNCLabel()->UILabel{
        let label = UILabel(frame: CGRect(x:0, y: (self.view.frame.height/2)-20, width: self.view.frame.width, height: 40))
        label.text = "No Internet Connection Available"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        return label
    }
    func initialSetup(){

            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.view.frame.width/2)-10, y: (self.view.frame.height/2)-10, width: 20, height: 20))
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.style = .whiteLarge
            self.activityIndicator.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidesWhenStopped = true

    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.addLogo()
        self.initialSetup()
        self.hideContent()
        setupReachability()
        updateShadow(navigationController: self.navigationController!)
                        NotificationCenter.default.addObserver(self, selector: #selector(handleOptionsLoaded(notification:)), name: AppPurchaseService.recieptsCheckedNotification, object: nil)
      
    }
    
    
    var isValidReceipt:Bool?{
        didSet{
            if (isValidReceipt == true ){
                if let lastReceipt = AppPurchaseService.shared.receipts.last {
                    WorkingSubscription.shared.presentSubscriptionReceipt = lastReceipt
                    goToMain()
                }
            }
        }
    }
    
    @objc func handleOptionsLoaded(notification: Notification) {
        print("Notification called \(AppPurchaseService.receiptIsAvailable)")
        if AppPurchaseService.receiptIsAvailable{
            DispatchQueue.main.async { [weak self] in
                if let lastReceipt = AppPurchaseService.shared.receipts.last {
                    self?.isValidReceipt = lastReceipt.isValid()
                    if !lastReceipt.isValid(){
                        self!.stopanimate()
                        self!.showContent()
                    }
                }else{
                    self!.stopanimate()
                    self!.showContent()
                }
            }
        }else{
            //not available
            stopanimate()
            showContent()
            print("Called Not Available receipt")
        }
    }
    
    
    func goToMain(){
        if !requestRecieved{
            let controller:UITabBarController
            controller = (self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController)!
            present(controller, animated: true, completion: nil)
            requestRecieved = true
        }
        
        
        
    }
    
    
    func checkfirstlaunch(){
        let checkForSub = UserDefaults.standard.object(forKey: "isFirstTimeSubscribed")
        let checkSubBool = UserDefaults.standard.bool(forKey: "isFirstTimeSubscribed")
        if checkForSub != nil{
            if checkSubBool==true {
                AppPurchaseService.shared.getProducts()
                AppPurchaseService.shared.uploadReceipt()
            }else{
                //need to subscribe
                stopanimate()
                showContent()
            }
        }else{
            //need to subscribe
            stopanimate()
            showContent()
        }
        
    }

}

