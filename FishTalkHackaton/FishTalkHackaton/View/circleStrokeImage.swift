//
//  circleStrokeImage.swift
//  Hoola
//
//  Created by Onur Hüseyin Çantay on 22.01.2018.
//

import UIKit

class circleStrokeImage: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
    }

}
