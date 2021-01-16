//
//  MasterVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 21/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit
enum direction{
    case left
    case right
}
protocol SwipeDelegate{
    func setSwipe(direction:direction)
}
class MasterVC: UIViewController,ModifyCategoryDelegate,SwipeDelegate {
    
    
    let reachability = Reachability()!
    var NCLabel:UILabel!
    
    func setSwipe(direction: direction) {
        if navigationVC != nil {
            navigationVC?.swipedir = direction
        }
        
    }
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableDetailView: UIView!
    
    
    var delegate:SwipeDelegate?
    
    var tableDetailVC:TableDetailVC?
    var navigationVC:NavigationVC?
    
    
    func setCategory(categoryName: String) {
        if self.tableDetailVC != nil {
            tableDetailVC?.currentCategory = categoryName
            tableDetailVC?.updateContent()
          
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReachability()
        addShadowToBar(navigationController: self.navigationController!)
        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        self.navigationItem.addLogo()
        updateShadow(navigationController: self.navigationController!)
        
       
    }
    
    func createNCLabel()->UILabel{
        let label = UILabel(frame: CGRect(x:0, y: (self.view.frame.height/2)-20, width: self.view.frame.width, height: 40))
        label.text = "No Internet Connection Available"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        return label
    }
    
 
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if sender.direction == .left {
            delegate!.setSwipe(direction: .left)
        }
        if sender.direction == .right {
            delegate!.setSwipe(direction: .right)
        }
    }
    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? NavigationVC{
            navigationVC.delegate = self
            self.navigationVC = navigationVC
        }
        
        if let tableDetailVC = segue.destination as? TableDetailVC{
            self.tableDetailVC = tableDetailVC
        }
        
        
        
        if let detVC = segue.destination as? TableDetailVC{
            detVC.delegate = self
        }
    }
    
    

//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//

}
