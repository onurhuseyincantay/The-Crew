//
//  Extension.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0.1, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
extension UITabBar{
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
      //  updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        self.backgroundImage = gradientLayer.creatGradientImage()
    }
}

extension UIViewController{
    func showDefaultAlert(title: String, message: String, button: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDefaultAlert(title: String, message: String, button: String, action: @escaping ((UIAlertAction) -> Void)){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: action))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDefaultConfirmAlert(title: String, message: String, action: @escaping ((UIAlertAction) -> Void)){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Evet", style: UIAlertActionStyle.default, handler: action))
            alert.addAction(UIAlertAction(title: "İptal", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension Date{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd::mm"
        dateStringFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
    
    
    func toString() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year,.second], from: self)
        if let day = components.day, let month = components.month, let year = components.year {
            if day < 10{
                return "\(String(year))-\(String(month))-0\(String(day))"
            }
            return "\(String(year))-0\(String(month))-\(String(day))"
        } else {
            return ""
        }
    }

}

let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    func loadImagesWithCache (urlString : String ) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                DispatchQueue.main.async{
                    if let downloadImage = UIImage(data : data!) {
                        imageCache.setObject(downloadImage, forKey: urlString as NSString)
                        self.image = downloadImage
                    }
                }
            }).resume()
        }
    }
}

