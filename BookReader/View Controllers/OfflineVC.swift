//
//  OfflineVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 04/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

extension MasterVC{
        func setupReachability(){
            reachability.whenReachable = { _ in
              self.navigationView.isHidden = false
            self.tableDetailView.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                self.navigationItem.rightBarButtonItem?.isEnabled = true

            }
            reachability.whenUnreachable = { _ in
                self.navigationView.isHidden = true
                self.tableDetailView.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                let label = self.createNCLabel()
                self.view.addSubview(label)
                self.NCLabel = label

            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: .reachabilityChanged, object: reachability)
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Error in starting")
            }
            
        }
        
        @objc func internetChanged(note:Notification) {
            
            let reachability = note.object as! Reachability
            if(reachability.connection != Reachability.Connection.none) {
                //reachable
                
                if self.NCLabel != nil{
                    self.NCLabel.isHidden = true
                }
                
                self.navigationView.isHidden = false
                self.tableDetailView.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else{
                //not reachable
                self.navigationView.isHidden = true
                self.tableDetailView.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                
                if self.NCLabel != nil{
                    self.NCLabel.isHidden = false
                }else{
                    let label = self.createNCLabel()
                    self.view.addSubview(label)
                    self.NCLabel = label
                }
                

            }
            
        }
    }


extension CheckSubscriptionVC{
    
    @objc func internetChanged(note:Notification) {
        
        let reachability = note.object as! Reachability
        if(reachability.connection != Reachability.Connection.none) {
            //reachable
            if self.NCLabel != nil{
                self.NCLabel.isHidden = true
            }
            self.checkfirstlaunch()
        }else{
            //not reachable
            if self.NCLabel != nil{
                self.NCLabel.isHidden = false
            }else{
                let label = self.createNCLabel()
                self.view.addSubview(label)
                self.NCLabel = label
            }
            self.stopanimate()
           self.hideContent()
            
        }
        
    }
    
    func setupReachability(){
        reachability.whenReachable = { _ in
           
            self.checkfirstlaunch()
        }
        reachability.whenUnreachable = { _ in
            self.stopanimate()
            let label = self.createNCLabel()
            self.view.addSubview(label)
            self.NCLabel = label
            self.hideContent()
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Error in starting")
        }
        
    }
}
    
    
    


