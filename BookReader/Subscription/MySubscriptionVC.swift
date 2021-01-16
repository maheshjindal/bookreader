//
//  MySubscriptionVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 12/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import UIKit

class MySubscriptionVC: UIViewController {
    @IBOutlet weak var subscriptionName: UILabel!
    @IBOutlet weak var subscriptionExpiryDate: UILabel!
    @IBOutlet weak var subscriptionPurchaseDate: UILabel!
    @IBOutlet weak var subscriptionId: UILabel!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let presentSubscription = WorkingSubscription.shared.presentSubscriptionReceipt
        
        if presentSubscription != nil {
            self.subscriptionName.text = getNameFromIdentifier(identifier: (presentSubscription?.product_id)!)
            self.subscriptionId.text = presentSubscription?.transactionId
            self.subscriptionPurchaseDate.text = presentSubscription?.purchase_date.getDate()
            self.subscriptionExpiryDate.text = presentSubscription?.expire_date.getDate()
        }else{
            DispatchQueue.main.async {
                self.initialSetup()
            }
          
        }
        
        self.navigationItem.addLogo()
        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        updateShadow(navigationController: self.navigationController!)
        
          NotificationCenter.default.addObserver(self, selector: #selector(handleOptionsLoaded(notification:)), name: WorkingSubscription.workingSubscriptionAvailable, object: nil)
        
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
    
    
    @objc func handleOptionsLoaded(notification: Notification) {
        if WorkingSubscription.shared.presentSubscriptionReceipt != nil{
            
            DispatchQueue.main.async {
                let presentSubscription = WorkingSubscription.shared.presentSubscriptionReceipt
                self.subscriptionName.text = self.getNameFromIdentifier(identifier: (presentSubscription?.product_id)!)
                self.subscriptionId.text = presentSubscription?.transactionId
                self.subscriptionPurchaseDate.text = presentSubscription?.purchase_date.getDate()
                self.subscriptionExpiryDate.text = presentSubscription?.expire_date.getDate()
                self.activityIndicator.stopAnimating()
            }

        }
    }
    
    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    private func getNameFromIdentifier(identifier:String)->String{
        switch identifier {
        case AppPurchaseSubscription.annualSubscription.rawValue: return "Annual Subscription"
        case AppPurchaseSubscription.monthlySubscription.rawValue: return "One Month Subscription"
        case AppPurchaseSubscription.semiannualSubscription.rawValue: return "Six Months Subscription"
        case AppPurchaseSubscription.weeklySubscription.rawValue: return "One Week Subscription"
        default: return "Not Recognized"
        }
    }

    @IBAction func cancelSubscription(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")!)
        
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
extension Date{
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
