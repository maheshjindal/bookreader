//
//  MyMangaMainVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 23/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class MyMangaMainVC: UITableViewController,TransferComicDelegate,CheckItemsDelegate{
    @IBOutlet weak var lastReadView: UIView!
    @IBOutlet weak var continueReadingLabel: UILabel!
    @IBOutlet weak var myMangasLabel: UILabel!
    @IBOutlet weak var myMangaCollectionView: UIView!
    var currentComic:Comic?{
        didSet{
            setupHiddenProperties(value: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.continueViewClicked))
        self.lastReadView.addGestureRecognizer(gesture)
        setupHiddenProperties(value: true)
       
        self.navigationItem.addLogo()
        addSearchBtn(navigationItem: self.navigationItem, target:self, action:#selector(goToSearch))
        updateShadow(navigationController: self.navigationController!)
    }
    @objc func goToSearch(){
        
        var controller:SearchVC
        controller = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func isItemAvailable(item: Bool) {
        if item{
            print("reached")
            myMangasLabel.isHidden = false
        }else{
            myMangasLabel.isHidden = true
        }
    }
    
    @objc func continueViewClicked(){
        print("clicked")
        var controller:ChaptersVC
        controller = storyboard?.instantiateViewController(withIdentifier: "ChaptersVC") as! ChaptersVC
        if let currentComic = self.currentComic{
            controller.currentComic = currentComic
            controller.bookId = currentComic.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let continueVC = segue.destination as? ContinueVC{
            continueVC.delegate = self
        }
            
            if let mycomicsview = segue.destination as? MyComicsVC{
                mycomicsview.delegate = self
            }
       
    }
    func setComic(comic: Comic) {
        self.currentComic = comic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupHiddenProperties(value:Bool){
        self.lastReadView.isHidden = value
        self.continueReadingLabel.isHidden = value
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
