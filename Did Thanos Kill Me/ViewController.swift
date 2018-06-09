//
//  ViewController.swift
//  Did Thanos Kill Me
//
//  Created by Mahad Mubbasher on 10/05/2018.
//  Copyright © 2018 Mahad Mubbasher. All rights reserved.
//

import UIKit
import AACameraView

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cameraView: AACameraView!
    @IBOutlet weak var killButton: UIButton!
    //@IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraView.startSession()
        cameraView.toggleCamera()
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
        
        cameraView.response = { response in

            if let url = response as? URL {

                // Recorded video URL here

            } else if let img = response as? UIImage {

                // Capture image here
                
                self.cameraView.captureImage()

            } else if let error = response as? Error {

                // Handle error if any!

            }
        }

        func viewWillDisappear(_ animated: Bool) {

                cameraView.stopSession()
            }
        
    }
    
    //MARK : Splitting the image.
    
    var imageArr = [[UIImage]]() //will contain small pieces of image //Note: this is an array of arrays
    
    
    //    func moveRight(view: UIImage) {
    //
    //        imgImage.frame.origin.x += 300
    //    }
    
    func splitImage(row : Int , column : Int) {
        
        let oImg = imageView.image
        
        var height =  (imageView.image?.size.height)! /  CGFloat (row) //height of each image tile
        var width =  (imageView.image?.size.width)!  / CGFloat (column)  //width of each image tile
        
        let scale = (imageView.image?.scale)! //scale conversion factor is needed as UIImage make use of "points" whereas CGImage use pixels.
        
        //            var imageArr = [[UIImage]]() //will contain small pieces of image //Note: this is an array of arrays
        
        for y in 0..<row {
            
            var yArr = [UIImage]()
            
            for x in 0..<column{
                
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width:width, height:height),
                    false, 0)
                let i =  oImg?.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: width * scale  , height: height * scale) )
                
                let newImg = UIImage.init(cgImage: i!)
                
                yArr.append(newImg)
                
                UIGraphicsEndImageContext()
                
            }
            
            imageArr.append(yArr)
            
        }
        
        print("rows: \(row), cols: \(column), imageArr.count: \(imageArr.count), imageArr[0].count: \(imageArr[0].count)")
        
        
        // Create New Image from split tiles in Array
        let row = imageArr.count
        let column = imageArr[0].count
        
        height =  (imageView.frame.size.height) /  CGFloat (row )
        width =  (imageView.frame.size.width) / CGFloat (column )
        
        print("For forward block creation from row: \(row), col: \(column), height: \(height), width: \(width)")
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageView.frame.size.width , height: imageView.frame.size.height))
        
        for y in 0..<row{
            
            for x in 0..<column{
                
                let newImage = imageArr[y][x]
                
                newImage.draw(in: CGRect.init(x: CGFloat(x) * width, y:  CGFloat(y) * height  , width: width - 1  , height: height - 1 ))
                
                print("Values for imageArr[\(y)][\(x)]): ", imageArr[y][x])
            }
        }
        
        let originalImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = originalImg
        
        
        // MARK: Animate Disintegrating
        
        print("For reverse block creation from row: \(row), col: \(column)")
        // reverse count for last parts of the image to disintegrate first- goes to index 0 (using to: -1 in stride)
        
        for r in stride(from: row - 1, to: -1, by: -1) {
            print("r: ",r)
            
            for c in stride(from: column - 1, to: -1, by: -1) {
                print("c: ",c)
                
                print("index in imageArr[\(r)][\(c)] is:", imageArr[r][c])
                
                //The disintegration block and Adding the image to UIimageview
                
                let imgBlock = UIImageView(frame: CGRect(x: CGFloat(r)+width , y: CGFloat(c), width: width, height: height))
                
                imgBlock.contentMode = .scaleAspectFit
                imgBlock.image = imageArr[r][c]
                //                    imgBlock.image = imageArr[r].last
                view.addSubview(imgBlock)
                
                let delay : Double = 0.25
                let duration : Double = 2.0
                
                UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                    imgBlock.center.x += 350
                    
                }) { (_) in
                    
                }
                
                
            }
        }
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func splitImagePressed(_ sender: Any) {
        
        splitImage(row: 3, column: 5)
        //createNewImage(imageArr: [[UIImage]]())
    }
    
    //MARK : Moving the image.
    
    //    UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
    
//    self.moveRight(view: self.black3)
//
//  }) { (_) in
//
//    self.moveLeft(view: self.black3)
//}
//
//UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
//
//    self.moveRight(view: self.red)
//
//}) { (_) in
//
//    self.moveLeft(view: self.red)
//}
//
//UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
//
//    self.moveRight(view: self.blue)
//
//}) { (_) in
//
//    self.moveLeft(view: self.blue)
//}
//
//UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
//
//    self.moveRight(view: self.green)
//
//}) { (_) in
//
//    self.moveLeft(view: self.green)
//}
//
//UIView.animate(withDuration: duration, delay: 0, options: .autoreverse, animations: {
//
//    self.moveRight(view: self.orange)
//
//}) { (_) in
//
//    //            self.moveLeft(view: self.orange)
//}
//
//
//}
}
