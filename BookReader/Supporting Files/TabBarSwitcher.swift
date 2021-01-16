//
//  TabBarSwitcher.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 28/11/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
import Foundation

@objc protocol TabBarSwitcher {
    func handleSwipes(sender:UISwipeGestureRecognizer)
}

extension TabBarSwitcher where Self: UIViewController {
    
    func initSwipe( direction: UISwipeGestureRecognizer.Direction){
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TabBarSwitcher.handleSwipes(sender:)))
        
        swipe.direction = direction
        print(swipe.direction)
        self.view.addGestureRecognizer(swipe)
    }
    
}
