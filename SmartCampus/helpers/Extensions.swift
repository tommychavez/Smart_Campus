//
//  Extensions.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 4/21/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import FirebaseDatabase

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    //caching
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        guard let url2 = URL(string: urlString) else {return
        }
        URLSession.shared.dataTask(with: url2 ) { (data, repsonse,error) in
            guard let data = data else {return}
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                //  cell.imageView?.image = UIImage(data: data)
               self.image = downloadedImage
                }
                
            }
            
        }.resume()
    }
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIViewController{
    func screenShotMethod() {
        //Create the UIImage
        //  UIGraphicsBeginImageContext(view.frame.size, true, 0.0)
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        screenshot = image.image(alpha: 0.25)
        //Save it to the camera roll
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
    func findStringOfTime(newDate: Int)-> String{
    var difference =  Int( Date().timeIntervalSince1970 ) - newDate;
    var timeStampString: String
    if(difference<60){
    if(difference<10){
    timeStampString = "Just Posted"
    return timeStampString
    }
    else {
    timeStampString = String(difference)
    return "\(timeStampString) seconds ago"
    }
    }
    
    else if(difference < 3600){
    difference = difference/60
    timeStampString = String(difference)
    if(timeStampString == "1"){
    timeStampString = "\(timeStampString) minute ago"
        return timeStampString
    }
    else{
    timeStampString = "\(timeStampString) minutes ago"
    return timeStampString
    }
    }
    
    else if(difference < 86400){
    difference = difference/3600
    timeStampString = String(difference)
    if(timeStampString == "1"){
    timeStampString = "\(timeStampString) hour ago"
    return timeStampString
    }
    else{
    timeStampString = "\(timeStampString) hours ago"
    return timeStampString
    }
    
    }
    
    else {//if(difference < 86400){
    difference = difference/86400
    timeStampString = String(difference)
    if(timeStampString == "1"){
    timeStampString = "\(timeStampString) day ago"
    return timeStampString
    }
    else{
    timeStampString = "\(timeStampString) days ago"
        return timeStampString
    }
    
    }

    }
    
        
        func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(index)
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    
}


extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


extension UIImage {
    
    func colorized(color : UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
          //  context.setBlendMode(.multiply)
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(self.cgImage!, in: rect)
            context.clip(to: rect, mask: self.cgImage!)
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return colorizedImage!
        
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }

}

extension UITextView {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }

}
