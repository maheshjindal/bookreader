//
//  AppPurchaseSubscription.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 11/01/19.
//  Copyright © 2019 hashbnm. All rights reserved.
//

import Foundation
import StoreKit



class AppPurchaseService:NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static var receiptIsAvailable = false
    private var contentFetched = false
    static let recieptsCheckedNotification = Notification.Name("RecieptsCheckedNotification")
    static let startLoaderNotification = Notification.Name("StartLoaderNotification")
    static let stopLoaderNotification = Notification.Name("StopLoaderNotification")
    static let goToHomePage = Notification.Name("GoToHomePage")
    private var purchasing = false
    var receipts:[Receipt]{
        didSet {
            if receipts.count > 0 {
                 NotificationCenter.default.post(name: AppPurchaseService.receiptsUpdatedNotification, object: receipts)
            }
        }
    }
    
    static let sessionIdSetNotification = Notification.Name("SubscriptionServiceSessionIdSetNotification")
     static let receiptsUpdatedNotification = Notification.Name("ReceiptsUpdatedNotification")
    
    
    private let itcAccountSecret = "c64a236b7a2a4c5fa41fc6e5b2bda66b"
    
    static let productsLoadedNotification = Notification.Name("SubscriptionServiceProductsLoadedNotification")
    var products:[SKProduct]?{
        didSet{
            
            NotificationCenter.default.post(name: AppPurchaseService.productsLoadedNotification, object: products)
        }
    }
    let defaultPayementQueue = SKPaymentQueue.default()
    static let shared = AppPurchaseService()
    
    private override init() {
        self.receipts = []
    }
    
    func getProducts(){
        let products:Set = [AppPurchaseSubscription.weeklySubscription.rawValue,
                            AppPurchaseSubscription.monthlySubscription.rawValue,
                            AppPurchaseSubscription.semiannualSubscription.rawValue,
                            AppPurchaseSubscription.annualSubscription.rawValue ]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        self.defaultPayementQueue.add(self)
    }
    
    func restorePurchases() {
        self.defaultPayementQueue.restoreCompletedTransactions()
    }
    
    func purchase(product:SKProduct) {
        let payement = SKPayment(product: product)
        self.defaultPayementQueue.add(payement)
    }
    
    func updateUserValue(){
        if (UserDefaults.standard.object(forKey: "isFirstTimeSubscribed") == nil)
        {
            UserDefaults.standard.set(true, forKey: "isFirstTimeSubscribed")
        }else{
            print("not able to reach")
        }
    }
    

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        self.uploadReceipt()
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchased:
                NotificationCenter.default.post(name: AppPurchaseService.stopLoaderNotification, object: nil)
                AppPurchaseService.shared.uploadReceipt()
                self.updateUserValue()
                NotificationCenter.default.post(name: AppPurchaseService.goToHomePage, object: nil)
            case .purchasing:
                 NotificationCenter.default.post(name: AppPurchaseService.startLoaderNotification, object: nil)
                purchasing = true
                break
            case .failed:
                NotificationCenter.default.post(name: AppPurchaseService.stopLoaderNotification, object: nil)
                purchasing = false
                break
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print(response.products)
        self.products = response.products
        uploadReceipt()
        if let products = self.products {
            if formatter.locale != products[0].priceLocale {
                formatter.locale = products[0].priceLocale
            }
        }
    }
    
    
    
    func uploadReceipt() {
        if let receiptData = loadReceipt() {
            AppPurchaseService.shared.upload(receipt: receiptData)
        }else{
            NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
        }
    }
    
    
    public func upload(receipt data: Data) {
        
        if (!contentFetched || purchasing){
            let body = [
                "receipt-data": data.base64EncodedString(),
                "password": itcAccountSecret
            ]
            let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
            
            let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData
            
            let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                if error != nil {
                    print(error ?? "Got Error")
                } else if let responseData = responseData {
                    let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String, Any>
                    
                    guard let receipt = json["receipt"] as? Dictionary<String,Any> else{
                        NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
                        return
                    }
                    guard let all_reciepts = receipt["in_app"] as? NSArray else{
                        NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
                        return
                    }
                    self.receipts = []
                    for curr_receipt in all_reciepts {
                        guard let curr_receipt = curr_receipt as? Dictionary<String, Any> else{
                            NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
                            return
                        }
                        guard let product_id = curr_receipt["product_id"] as? String, let transaction_id = curr_receipt["transaction_id"] as? String else{
                            
                            return
                        }
                        
                        guard let purchase_date = curr_receipt["purchase_date"], let expire_date = curr_receipt["expires_date"]   else{
                            return
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                        guard let purchaseDate = dateFormatter.date(from: purchase_date as! String) else {
                            return
                        }
                        guard let expireDate = dateFormatter.date(from: expire_date as! String) else{
                            return
                        }
                        let receipt = Receipt(purchaseDate: purchaseDate, expireDate: expireDate, productId: product_id, transactionId: transaction_id)
                        self.receipts.append(receipt)
                    }
                    self.receipts.sort(by: { (r0, r1) -> Bool in
                        r0.purchase_date < r1.purchase_date
                    })
                    let lastReceipt = self.receipts.last
                    if (lastReceipt != nil && lastReceipt!.isValid()){
                        WorkingSubscription.shared.presentSubscriptionReceipt = self.receipts.last
                    }
                    AppPurchaseService.receiptIsAvailable = true
                    NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
                    
                    NotificationCenter.default.post(name: AppPurchaseService.receiptsUpdatedNotification, object: self.receipts)
                    self.contentFetched = true
                }
            }
            
            task.resume()
        }
    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
            
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
//            print("Reached step 1")
            return data
        } catch {
            NotificationCenter.default.post(name: AppPurchaseService.recieptsCheckedNotification, object: AppPurchaseService.receiptIsAvailable)
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
}
extension SKPaymentTransactionState{
    func status(){
        switch self {
        case .deferred:
            print("Deferred")
        case .failed:
            print("Failed")
        case .purchased:
            print("Purchased")
        case .purchasing:
            print("Purchasing")
        case .restored:
            print("Restored")
            AppPurchaseService.shared.restorePurchases()
        }
    }
    

}


 var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.formatterBehavior = .behavior10_4
    
    return formatter
}()
