//
//  GradientButton.swift
//  FishTalkHackaton
//
//  Created by Onur Hüseyin Çantay on 10.02.2018.
//  Copyright © 2018 Onur Hüseyin Çantay. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GradientButton: UIButton {
    //    case .leftRight:
    //    return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
    //    case .rightLeft:
    //    return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
    //    case .topBottom:
    //    return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
    //    case .bottomTop:
    //    return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
    //    case .topLeftBottomRight:
    //    return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
    //    case .bottomRightTopLeft:
    //    return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
    //    case .topRightBottomLeft:
    //    return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
    //    case .bottomLeftTopRight:
    //    return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
    
    @IBInspectable var startColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var endColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var endPointY: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowBlur
        layer.shadowOpacity = 1
        var sublayer = CALayer()
        sublayer.backgroundColor = UIColor.white.cgColor
        sublayer.shadowOffset = CGSize(width: 0, height: 3);
        sublayer.shadowRadius = 5.0
        sublayer.shadowColor = UIColor.black.cgColor
        sublayer.shadowOpacity = 0.8;
        sublayer.cornerRadius = 12.0
        sublayer.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: self.frame.width, height: self.frame.height)
        sublayer.borderColor = UIColor.black.cgColor;
        sublayer.borderWidth = 0.5
        sublayer.contents = self.titleLabel
        layer.insertSublayer(sublayer, at: 0)
    }
    
}


