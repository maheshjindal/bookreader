//
//  MainCategoryVC.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 22/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import UIKit

class MainCategoryVC: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    fileprivate let itemsPerRow:CGFloat = 1
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10.0, bottom: 5, right: 10.0)
    @IBOutlet weak var collectionView: UICollectionView!
    var tableDetailViewController:TableDetailVC?
    
    var mainComicsList:[Comic]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    
    private var mainItemsCount = 6
    var isFetched = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mainComicsList?.count != nil {
            return (self.mainComicsList?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? ImageCollectionViewCell
            if(self.mainComicsList?.count != nil){
                if let currComic = self.mainComicsList?[indexPath.row] {
                    cell?.comic = currComic
            }
            
        }
        return cell!;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currComic = self.mainComicsList?[indexPath.row] {
            tableDetailViewController!.showCategoryDetails(item: currComic)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    
    
    
}
