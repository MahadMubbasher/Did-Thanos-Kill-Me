//
//  ViewController.swift
//  Did Thanos Kill Me
//
//  Created by Mahad Mubbasher on 10/05/2018.
//  Copyright © 2018 Mahad Mubbasher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var killButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.image = #imageLiteral(resourceName: "Thanos and His Moon")
    }

    func determineDeath() {
        
        var chanceOfDying = arc4random_uniform(2)
        
        print(chanceOfDying)
        
        if chanceOfDying == 0 {
            
            textLabel.text = "You were slain by Thanos, for the good of the Universe."
            killButton.isEnabled = false
            
        } else {
            
            textLabel.text = "You have been spared by Thanos."
            killButton.isEnabled = false
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        determineDeath()
        
        
    }
    
    //MARK : Splitting the image.
    
    //
    
    func splitImage(row : Int , column : Int){
        
        let oImg = imageView.image
        
        let height =  (imageView.image?.size.height)! /  CGFloat (row) //height of each image tile
        let width =  (imageView.image?.size.width)!  / CGFloat (column)  //width of each image tile
        
        let scale = (imageView.image?.scale)! //scale conversion factor is needed as UIImage make use of "points" whereas CGImage use pixels.
        
        var imageArr = [[UIImage]]() // will contain small pieces of image
        
        for y in 0..<row{
            var yArr = [UIImage]()
            for x in 0..<column{
                
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width:width, height:height),
                    false, 0)
                let i =  oImg?.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: width * scale  , height: height * scale) )
                
                let newImg = UIImage.init(cgImage: i!)
                
                yArr.append(newImg)
                
                UIGraphicsEndImageContext();
                
            }
            
            imageArr.append(yArr)
        }
        
    }
    
    func createNewImage(imageArr : [[UIImage]]){
        
        let row = imageArr.count
        let column = imageArr[0].count
        let height =  (imageView.frame.size.height) /  CGFloat (row )
        let width =  (imageView.frame.size.width) / CGFloat (column )
        
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageView.frame.size.width , height: imageView.frame.size.height))
        
        for y in 0..<row{
            
            for x in 0..<column{
                
                let newImage = imageArr[y][x]
                
                newImage.draw(in: CGRect.init(x: CGFloat(x) * width, y:  CGFloat(y) * height  , width: width - 1  , height: height - 1 ))
                
            }
        }
        
        let originalImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        imageView.image = originalImg
    }
    
    //MARK : Moving the image.
    
    func moveRight(view: UIView) {
        
        imageView.image.center.x += 50
    }
    
}



