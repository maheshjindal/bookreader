//
//  SupportingMethods.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 03/12/18.
//  Copyright © 2018 Mahesh Jindal. All rights reserved.
//

import Foundation
import UIKit
var associateObjectValue: Int = 0

extension UISearchBar{
   func addCancelView(){
    
    }
}
    func fetchImageFromURL(link:String) -> UIImage {
            let imageURL = URL(string: link)!
            var imageData:Data!
        
            do{
                try imageData = Data(contentsOf: imageURL)
            }catch {
                print(imageURL)
                print("Unable to load image data")
            }
        
        if(imageData != nil){
            return UIImage(data: imageData)!
        }
        return UIImage(named: "network.png")!
    }

func findNameFromCategory(categoryName : String) -> String {
    let catname = categoryName.lowercased()
        return catname.replacingOccurrences(of: " ", with: "+")
}
extension UINavigationItem{
    func addLogo(){
//        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        logo.image = #imageLiteral(resourceName: "whitemonster").withRenderingMode(.alwaysTemplate)
//        logo.contentMode = .scaleAspectFit
//        logo.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
//        logo.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        logo.addRadius(shadow_color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), curveFactor: 4)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        title.text = "MANGA MONSTER"
        self.leftBarButtonItem = UIBarButtonItem(customView: title)
        self.title = ""
        title.font = UIFont(name: "Copperplate", size: 22)
        title.textAlignment = .left
        title.layer.shadowColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.layer.opacity = 0.9
//        title.layer.shadowOpacity = 0.9
//        title.layer.shadowRadius = 1.0
        title.translatesAutoresizingMaskIntoConstraints = false
    }
}


func addShadowToBar(navigationController: UINavigationController) {
    navigationController.navigationBar.layer.masksToBounds = false
    navigationController.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
    navigationController.navigationBar.layer.shadowOpacity = 0.3
    navigationController.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.2)
    navigationController.navigationBar.layer.shadowRadius = 0.2
    
}
func addSearchBtn(navigationItem: UINavigationItem, target:Any?, action:Selector){
    let button = UIButton()
    button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
    button.layer.borderWidth = 0.1
    button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    button.layer.cornerRadius = button.frame.width*0.5
//    button.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    button.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//    button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    button.layer.shadowOpacity = 0.3
//    button.layer.shadowRadius = 0.3
    button.addTarget(target, action: action, for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
}

func addFavouriteButton(navigationItem: UINavigationItem, target:Any?, action:Selector)->UIButton{
    let button = UIButton()
    button.frame = CGRect(x: 0, y: 0, width:40 , height: 40)
//    button.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysTemplate), for: .normal)
//    button.layer.borderWidth = 1.0
//    button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    button.layer.cornerRadius = button.frame.width*0.5
//    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    button.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//    button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    button.layer.shadowOpacity = 0.5
//    button.layer.shadowRadius = 1.0
//    button.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
    button.addTarget(target, action: action, for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    return button
}


func updateShadow(navigationController: UINavigationController){
//    navigationController.navigationBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    navigationController.navigationBar.layer.shadowOpacity = 0.4
//    navigationController.navigationBar.layer.shadowRadius = 0.5
//    navigationController.navigationBar.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
    navigationController.navigationBar.shadowImage = UIImage()


    
}

extension UIButton{
    func updateButtonLayout(){
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height/3.0
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.opacity = 0.7
        self.tintColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
    }
}
extension UILabel{
    func makeCircle(){
        self.textColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        self.layer.cornerRadius = self.frame.width * 0.3
        self.layer.shadowColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
        
    }
    func updateColor(){
        self.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
    
    func makeNonColorCircle(){
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius = self.frame.width * 0.2
        self.layer.shadowColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
    }
    
    func addBottomBorder(){
        let border = CALayer()
        border.name = "bottomBorder"
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - 0.8, width: self.frame.size.width, height: 2.0)
        border.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        border.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        border.shadowOffset = CGSize(width: 0.4, height: 0.6)
        border.shadowOpacity = 0.4
        self.layer.addSublayer(border)
    }
    func removeBottomBorder(){
        if self.layer.sublayers?.count != nil {
            for layer in self.layer.sublayers!{
                if layer.name == "bottomBorder"{
                    layer.removeFromSuperlayer()
                    self.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                    
                }
            }
        }
    }
    
    
    func makeShadow(){
        self.layer.shadowColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        
    }
}

extension UIImageView{
    func addRadius(shadow_color: CGColor, curveFactor:CGFloat){
        self.layer.cornerRadius = self.frame.height/(curveFactor*1.5)
        self.layer.shadowColor = shadow_color
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 2.5, height: 2.0)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.3
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
   
    func addShadowAndRadius(shadow_color: CGColor, curveFactor:CGFloat){
//        self.layer.cornerRadius = self.frame.height/curveFactor
        let shadowLayer = self.layer
        shadowLayer.shadowColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 1.0
        shadowLayer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        shadowLayer.masksToBounds = true

//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    
    
    func addShadow(shadow_color: CGColor){
        self.layer.shadowColor = shadow_color
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.contentMode = .scaleAspectFit
        
    }
}


extension UIView{
    
    func addShadowToView(shadow_color:CGColor){
        self.layer.cornerRadius = self.frame.size.width/12
        self.layer.shadowColor = shadow_color
        self.layer.shadowRadius = 0.7
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = self.frame.size.width/12
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.masksToBounds = false
    }
    func addTopBorder(){
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.8)
        border.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        border.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        border.shadowOffset = CGSize(width: 0.4, height: 0.6)
        border.shadowOpacity = 0.4
        self.layer.addSublayer(border)
    }
    
}

extension UILabel{
    func setupDetails(){
        self.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 15)
        self.textAlignment = .left
        self.layer.shadowColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.opacity = 0.9
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.2, height: 0.3)
        self.text = self.text?.uppercased()
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
extension UIProgressView{
   func addRadius(){
        self.transform.scaledBy(x: 1, y: 8)

        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.sublayers![1].cornerRadius = 5
        self.subviews[1].clipsToBounds = true
    }
}




extension UIView{
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? true
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
}

extension TableDetailVC {
    
    
    func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in view.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.shimmerAnimation
        })
    }
    
    
    func startAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.5
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    
    
    func stopAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
}

